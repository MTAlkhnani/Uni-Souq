import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/models/massage.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';

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

      // Retrieve first name and last name
      DocumentSnapshot userSnapshot =
          await _firestore.collection('User').doc(currentUserID).get();
      String firstName = userSnapshot.get('FirstName');
      String lastName = userSnapshot.get('LastName');

      // Create new Message
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        senderFirstName: firstName,
        senderLastName: lastName,
        receiverId: receiverID,
        message: message,
        imageUrl: imageUrl, // Pass imageUrl if it's an image message
        timestamp: timestamp,
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