import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unisouq/components/chat_babble.dart';
import 'package:unisouq/components/my_text_field.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingPage extends StatefulWidget {
  static const String id = 'massaging_page';

  final String receiverUserID;

  MessagingPage({Key? key, required this.receiverUserID}) : super(key: key);

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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
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
        InitializationSettings(
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
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverName), // Set the app bar title to receiver's name
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: _buildMessageInput(),
          ),
        ],
      ),
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
              return const Center(child: CircularProgressIndicator());
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
                  Center(
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

    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;

    String senderName = '${data['senderFirstName']} ${data['senderLastName']}';
    String messageSentTime = _formatTimestamp(data['timestamp']);

    return Container(
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
                  constraints: BoxConstraints(
                      maxWidth: 250), // Adjust maximum width as needed
                  padding: const EdgeInsets.all(8),

                  child: data['imageUrl'] != null
                      ? Image.network(
                          data['imageUrl'],
                          width: 200, // Adjust width as needed
                          height: 200, // Adjust height as needed
                        )
                      : ChatBubble(
                          message: data['message'],
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                messageSentTime,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
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
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: _controller,
            hintText: 'Enter message',
            keyboardType: TextInputType.text,
            obscureText: false,
          ),
        ),
        CircleAvatar(
          radius: 20,
          child: IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _getImageFromGallery,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_forward,
            size: 40,
          ),
        ),
      ],
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
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _showNotification(String senderName, String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message from $senderName',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
