import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unisouq/generated/l10n.dart';
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
            String fullName = '$firstName $lastName';

            // Fetch user image from the profile collection
            FirebaseFirestore.instance
                .collection('profile')
                .doc(userSnapshot.id)
                .get()
                .then((profileDoc) {
              var userImage = profileDoc.data()?['userImage'];

              setState(() {
                _usersMap[userSnapshot.id] = {
                  'name': fullName,
                  'userImage': userImage,
                };
              });
            });
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

    return S.of(context).Nomessagesavailable;
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
      body: _usersMap.isEmpty
          ? SpinKitWave(
              color: Theme.of(context).hintColor,
              size: 20.0,
            )
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
                  return SpinKitWave(
                    color: Theme.of(context).hintColor,
                    size: 20.0,
                  );
                }

                List<QueryDocumentSnapshot> chatRooms = snapshot.data!.docs;

                return chatRooms.isEmpty
                    ? Center(
                        child: Text(S.of(context).Noclientyou),
                      )
                    : ListView.builder(
                        itemCount: chatRooms.length,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot room = chatRooms[index];
                          List<dynamic> participants = room['participants'];
                          String? otherUserId = participants.firstWhere(
                            (id) =>
                                id != FirebaseAuth.instance.currentUser!.uid,
                            orElse: () => null,
                          ) as String?;

                          if (otherUserId == null) {
                            // Handle the case where otherUserId is null
                            return const SizedBox.shrink();
                          }

                          String userName = _usersMap[otherUserId]?['name'] ??
                              S.of(context).Usernotfound;
                          String chatRoomId = _getChatRoomId(otherUserId);

                          return FutureBuilder<int>(
                            future: getUnreadMessageCount(chatRoomId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  title: Text(userName),
                                  subtitle: const SpinKitThreeBounce(
                                    color: Colors.grey,
                                    size: 20.0,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                // Handle error case
                                return ListTile(
                                  title: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                int unreadMessages = snapshot.data!;
                                IconData messageIcon = unreadMessages > 0
                                    ? Icons.person
                                    : Icons.person;

                                return ListTile(
                                  leading: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: _usersMap[otherUserId]
                                                    ?['userImage'] !=
                                                null
                                            ? NetworkImage(
                                                _usersMap[otherUserId]
                                                    ?['userImage']!)
                                            : const AssetImage(
                                                    'assets/default_avatar.png')
                                                as ImageProvider,
                                        child: Icon(messageIcon),
                                      ),
                                      if (unreadMessages > 0)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red,
                                            ),
                                            child: Text(
                                              '$unreadMessages',
                                              style: const TextStyle(
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
                                        return const SpinKitThreeBounce(
                                          color: Colors.grey,
                                          size: 1.0,
                                        );
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
