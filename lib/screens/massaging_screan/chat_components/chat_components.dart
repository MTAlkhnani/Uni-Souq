import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisouq/models/massage.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import '../../../service/notification_service.dart';

// Import the NotificationService class

class ChatBubble extends StatelessWidget {
  final String message;
  final String? imageUrl; // Add imageUrl field

  const ChatBubble({Key? key, required this.message, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).primaryColor,
      ),
      child: imageUrl !=
              null // Conditionally render image or text based on imageUrl
          ? Image.network(
              imageUrl!,
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
              fit: BoxFit.cover, // Adjust fit as needed
            )
          : Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
    );
  }
}

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // Send message
  Future<void> sendMessage(String receiverID, String message,
      {String? imageUrl}) async {
    try {
      final String currentUserID = _firebaseAuth.currentUser!.uid;
      final String currentUserEmail =
          _firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();

      // Retrieve first name and last name of sender
      DocumentSnapshot userSnapshot =
          await _firestore.collection('User').doc(currentUserID).get();
      String senderFirstName = userSnapshot.get('FirstName');
      String senderLastName = userSnapshot.get('LastName');
      String senderEmail = userSnapshot.get('email');

      // Retrieve first name and last name of receiver
      DocumentSnapshot receiverSnapshot =
          await _firestore.collection('User').doc(receiverID).get();
      String receiverFirstName = receiverSnapshot.get('FirstName');
      String receiverLastName = receiverSnapshot.get('LastName');

      // Create new Message
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: senderEmail,

        receiverId: receiverID,

        message: message,
        imageUrl: imageUrl, // Pass imageUrl if it's an image message
        timestamp: timestamp, senderFirstName: senderFirstName,
        senderLastName: senderLastName,
        receiverFirstName: receiverFirstName,
        receiverLastName: receiverLastName,
      );

      List<String> ids = [currentUserID, receiverID];
      ids.sort();

      String chatRoomID = ids.join("_");

      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add(newMessage.toMap());

      
      
    } catch (e) {
      print('Failed to send message: $e');
    }
  }

  Stream<QuerySnapshot> getMessages(String userID, String otherUserId) {
    List<String> ids = [userID, otherUserId];

    ids.sort();
    String chatRoomID = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  void contactSeller(BuildContext context, String reciverUserID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingPage(
          receiverUserID: reciverUserID,
        ),
      ),
    );
  }
}
