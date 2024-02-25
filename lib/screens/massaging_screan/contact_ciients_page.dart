import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';

class ContactClientsPage extends StatefulWidget {
  static const String id = 'contact_clients_page';

  @override
  _ContactClientsPageState createState() => _ContactClientsPageState();
}

class _ContactClientsPageState extends State<ContactClientsPage> {
  late Map<String, Map<String, dynamic>> _usersMap;

  @override
  void initState() {
    super.initState();
    _usersMap = {};
    _fetchUsers();
  }

  void _fetchUsers() {
    FirebaseFirestore.instance
        .collection('User')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _usersMap = {};
        for (QueryDocumentSnapshot userSnapshot in snapshot.docs) {
          var data = userSnapshot.data() as Map<String, dynamic>?;
          var firstName = data?['FirstName'];
          var lastName = data?['LastName'];
          if (firstName != null && lastName != null) {
            _usersMap[userSnapshot.id] = {'name': '$firstName $lastName'};
          }
        }
      });
    });
  }

  Future<String> getLastMessage(String? userId) async {
    if (userId == null) {
      return 'No messages available';
    }

    final chatRoomId = _getChatRoomId(userId);
    if (chatRoomId == null) {
      return 'No messages available';
    }

    final messagesSnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (messagesSnapshot.docs.isNotEmpty) {
      final messageData = messagesSnapshot.docs.first.data();
      if (messageData != null && messageData['message'] != null) {
        return messageData['message'];
      }
    }

    return 'No messages available';
  }

  Future<int> getUnreadMessageCount(String chatRoomId) async {
    final unreadMessagesSnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('read', isEqualTo: false)
        .get();

    return unreadMessagesSnapshot.docs.length;
  }

  String _getChatRoomId(String userId) {
    List<String> participantIds = [
      FirebaseAuth.instance.currentUser!.uid,
      userId
    ];
    participantIds.sort();
    return participantIds.join("_");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Clients'),
      ),
      body: _usersMap.isEmpty
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .where('participants',
                      arrayContains: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> chatRooms = snapshot.data!.docs;

                return chatRooms.isEmpty
                    ? Center(
                        child: Text('No clients are contacting you.'),
                      )
                    : ListView.builder(
                        itemCount: chatRooms.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot room = chatRooms[index];
                          List<dynamic> participants = room['participants'];
                          String otherUserId = participants
                              .firstWhere((id) =>
                                  id != FirebaseAuth.instance.currentUser!.uid)
                              .toString();
                          String userName = _usersMap[otherUserId]!['name'] ??
                              'User not found';
                          String chatRoomId = _getChatRoomId(otherUserId);

                          return FutureBuilder<int>(
                            future: getUnreadMessageCount(chatRoomId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return ListTile(
                                  leading: Icon(Icons.account_circle),
                                  title: Text(userName),
                                  subtitle: Text('Loading...'),
                                );
                              } else {
                                int unreadMessages = snapshot.data!;
                                IconData messageIcon = unreadMessages > 0
                                    ? Icons.mail
                                    : Icons.mail_outline;

                                return ListTile(
                                  leading: Stack(
                                    children: [
                                      Icon(messageIcon),
                                      if (unreadMessages > 0)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Text(
                                              '$unreadMessages',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  title: Text(userName),
                                  subtitle: FutureBuilder<String>(
                                    future: getLastMessage(otherUserId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          !snapshot.hasData) {
                                        return Text('Loading...');
                                      } else {
                                        String lastMessage = snapshot.data!;
                                        return Text(lastMessage);
                                      }
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MessagingPage(
                                          receiverUserID: otherUserId,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      );
              },
            ),
    );
  }
}
