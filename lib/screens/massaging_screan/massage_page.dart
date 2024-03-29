import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:unisouq/components/chat_babble.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unisouq/screens/my_profile_page/my_profilepage.dart';
import 'package:unisouq/utils/size_utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class MessagingPage extends StatefulWidget {
  static const String id = 'massaging_page';

  final String receiverUserID;
  final String? initialMessage; // Optional initial message
  final String? productImage;

  MessagingPage(
      {Key? key,
      required this.receiverUserID,
      this.initialMessage,
      this.productImage})
      : super(key: key);

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final TextEditingController _controller = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  final ScrollController _scrollController = ScrollController();
  bool _isImageUploading = false;
  String _uploadedImageUrl = '';
  String receiverName = ''; // Variable to store receiver's name
  bool _showEmoji = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Set the initial message to the _controller if it's not null
    if (widget.initialMessage != null) {
      _controller.text = widget.initialMessage!;
    }
    _initializeNotifications();
    _fetchReceiverName(); // Fetch receiver's name when the page initializes
  }

  void _fetchReceiverName() async {
    try {
      DocumentSnapshot receiverSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.receiverUserID)
          .get();
      setState(() {
        receiverName =
            '${receiverSnapshot['FirstName']} ${receiverSnapshot['LastName']}';
      });
    } catch (e) {
      print('Error fetching receiver name: $e');
    }
  }

  void _initializeNotifications() async {
    final InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID, _controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showEmoji) {
          setState(() => _showEmoji = !_showEmoji);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(), // Set the app bar title to receiver's name
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: _buildMessageInput(),
            ),
            if (_isImageUploading)
              const SpinKitWave(
                color: Colors.grey,
                size: 20.0,
              ),
            if (_showEmoji)
              SizedBox(
                height: .35.h,
                child: EmojiPicker(
                  textEditingController: _controller,
                  config: Config(
                    bgColor: const Color.fromARGB(255, 234, 248, 255),
                    columns: 8,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Profile')
                .doc(widget.receiverUserID)
                .get(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                // return CircularProgressIndicator();
              }
              if (profileSnapshot.hasError) {
                return Text('Error: ${profileSnapshot.error}');
              }
              if (!profileSnapshot.hasData || !profileSnapshot.data!.exists) {
                return const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                );
              }
              var profileData =
                  profileSnapshot.data!.data() as Map<String, dynamic>;
              String profileImageUrl = profileData['userImage'] ?? '';
              String receiverName =
                  '${profileData['FirstName']} ${profileData['LastName']}';
              return GestureDetector(
                onTap: () {
                  // Navigate to the profile page when the avatar is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        userId: widget.receiverUserID,
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(profileImageUrl)
                          as ImageProvider
                      : const AssetImage('assets/images/profile_Defulat.jpg'),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receiverName,
                  style: const TextStyle(fontSize: 18),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user_activity')
                      .doc(widget.receiverUserID)
                      .snapshots(),
                  builder: (context, activitySnapshot) {
                    if (activitySnapshot.connectionState ==
                        ConnectionState.waiting) {
                      // return const Text(
                      //   'Loading...',
                      //   style: TextStyle(fontSize: 12),
                      // );
                    }
                    if (activitySnapshot.hasError) {
                      return Text(
                        'Error: ${activitySnapshot.error}',
                        style: const TextStyle(fontSize: 12),
                      );
                    }
                    if (!activitySnapshot.hasData ||
                        !activitySnapshot.data!.exists) {
                      return Text(
                        S.of(context).lastseen,
                        style: TextStyle(fontSize: 12),
                      );
                    }
                    var activityData =
                        activitySnapshot.data!.data() as Map<String, dynamic>;
                    bool isActive = activityData['isActive'] ?? false;
                    Timestamp lastSeen = activityData['lastSeen'];
                    String lastSeenTime;
                    if (isActive) {
                      lastSeenTime = S.of(context).Activenow;
                    } else {
                      lastSeenTime =
                          DateFormat.yMd().add_jm().format(lastSeen.toDate());
                    }
                    return Text(
                      lastSeenTime,
                      style: const TextStyle(fontSize: 12),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert), // Add your option icon here
          onPressed: () {
            // Implement the action for the option icon
          },
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return Stack(
      children: [
        StreamBuilder(
          stream: _chatService.getMessages(
            widget.receiverUserID,
            _firebaseAuth.currentUser!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox();
            }

            List<DocumentSnapshot> messageDocs = snapshot.data!.docs;
            List<Widget> messageWidgets = [];

            DateTime? currentDate;
            for (int i = 0; i < messageDocs.length; i++) {
              var document = messageDocs[i];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              DateTime messageDate = (data['timestamp'] as Timestamp).toDate();
              if (currentDate == null || !isSameDay(currentDate, messageDate)) {
                // Add date above the messages
                messageWidgets.add(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _formatDate(messageDate),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
                currentDate = messageDate;
              }
              // Add message item
              messageWidgets.add(_buildMessageItem(document));
            }

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scrollToBottom(); // Call scrollToBottom after the frame is built
            });

            return ListView(
              controller: _scrollController, // Attach the ScrollController here
              children: messageWidgets,
            );
          },
        ),
        Positioned(
          bottom: 30,
          right: 10,
          child: CircleAvatar(
            radius: 20,
            child: IconButton(
              color: Theme.of(context).scaffoldBackgroundColor,
              icon: const Icon(Icons.arrow_downward, color: Colors.white),
              onPressed: _scrollToBottom,
            ),
          ),
        ),
      ],
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    final bool isSender = data['senderID'] == _firebaseAuth.currentUser!.uid;

    var alignment =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    String senderName = '${data['senderFirstName']} ${data['senderLastName']}';
    String messageSentTime = _formatTimestamp(data['timestamp']);

    return GestureDetector(
      onTap: () {
        // Open the image when tapped
        if (data['imageUrl'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: CachedNetworkImage(
                    imageUrl: data['imageUrl'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            Text(
              senderName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: alignment == CrossAxisAlignment.start
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                        maxWidth: 250), // Adjust maximum width as needed
                    padding: const EdgeInsets.all(8),
                    child: ChatBubble(
                      message: data['message'],
                      imageUrl: data['imageUrl'],
                      isSender: isSender,
                      messageSentTime: messageSentTime, // Pass messageSentTime
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String hour = dateTime.hour.toString();
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = (dateTime.hour < 12) ? 'AM' : 'PM';
    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    } else if (dateTime.hour == 0) {
      hour = '12';
    }
    String formattedTime = '$hour:$minute $period';
    return formattedTime;
  }

  Widget _buildMessageInput() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.v),
        child: Row(
          children: [
            SizedBox(width: 5.v),
            SizedBox(width: 8.v),
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      maxLines:
                          null, // Allow the TextField to expand vertically
                      obscureText: false,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: InputDecoration(
                        hintText: S.of(context).TypeSomething,
                        hintStyle:
                            TextStyle(color: Theme.of(context).hintColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.flip_camera_ios,
                          color: Colors.white),
                      onPressed: _getImageFromGallery,
                    ),
                  ),
                  IconButton(
                    onPressed: sendMessage,
                    icon: Icon(
                      color: Theme.of(context).primaryColor,
                      Icons.arrow_forward_ios,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.v),
          ],
        ),
      ), // Added elevation to prevent overlapping with the next widgets
    );
  }

  Future<void> _getImageFromGallery() async {
    try {
      setState(() {
        _isImageUploading =
            true; // Set flag to indicate image upload is in progress
      });

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String imageName = DateTime.now()
            .millisecondsSinceEpoch
            .toString(); // Unique image name
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child('$imageName.jpg');
        await ref.putFile(imageFile);
        String imageUrl = await ref.getDownloadURL();
        _chatService.sendMessage(widget.receiverUserID, '', imageUrl: imageUrl);
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      setState(() {
        _isImageUploading = false; // Reset the flag when upload is complete
      });
    }
  }

  // Add this method to scroll to the bottom
  void _scrollToBottom() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }
}
