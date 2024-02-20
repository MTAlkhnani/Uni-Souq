import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/models/massage.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String receiverid, String message) async {
    try {
      final String currentUserID = _firebaseAuth.currentUser!.uid;
      final String currentUserEmail =
          _firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();

      //CREATE NEW MASSAGE

      Message newMessage = Message(
          senderID: currentUserID,
          senderEmail: currentUserEmail,
          receiverid: receiverid,
          message: message,
          timestamp: timestamp);

      List<String> ids = [currentUserID, receiverid];
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
          reciverUserID: reciverUserID,
        ),
      ),
    );
  }
}
