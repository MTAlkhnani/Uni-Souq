import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/models/massage.dart';
import 'package:unisouq/screens/massaging_screan/contact_ciients_page.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import 'package:unisouq/screens/notification_page/notification_page.dart';
import 'package:unisouq/utils/auth_utils.dart';

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

      // Retrieve first name and last name of receiver
      DocumentSnapshot receiverSnapshot =
          await _firestore.collection('User').doc(receiverID).get();
      String receiverFirstName = receiverSnapshot.get('FirstName');
      String receiverLastName = receiverSnapshot.get('LastName');

      // Create new Message
      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        senderFirstName: senderFirstName,
        senderLastName: senderLastName,
        receiverId: receiverID,
        receiverFirstName: receiverFirstName,
        receiverLastName: receiverLastName,
        message: message,
        imageUrl: imageUrl, // Pass imageUrl if it's an image message
        timestamp: timestamp,
      );

      // Sort participant IDs and create chat room ID
      List<String> participantIds = [currentUserID, receiverID];
      participantIds.sort();
      String chatRoomID = participantIds.join("_");

      // Check if the chat room already exists
      bool chatRoomExists = await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .get()
          .then((doc) => doc.exists);

      // If chat room doesn't exist, create it with participant information
      if (!chatRoomExists) {
        await _firestore.collection('chat_rooms').doc(chatRoomID).set({
          'participants': participantIds,
          'senderFirstName': senderFirstName,
          'senderLastName': senderLastName,
          'receiverFirstName': receiverFirstName,
          'receiverLastName': receiverLastName,
        });
      }

      // Add message to the messages subcollection of the chat room
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

  void contactSeller(BuildContext context, String receiverUserID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingPage(
          receiverUserID: receiverUserID,
        ),
      ),
    );
  }

  Future<void> requestToBuy(
      BuildContext context, Map<String, dynamic> productData) async {
    String sellerId = productData['sellerID'];
    String product = productData['title'] ?? 'Your Product';
    double listingPrice = double.parse(productData['price'] ?? '0.0');

    String message =
        "I'm interested to buy $product with the listing price $listingPrice";

    try {
      // Send message directly to the seller without navigating to the messaging page
      await sendMessage(sellerId, message);
      // Show dialog if message sent successfully

      // If you want to return something upon successful sending, you can return it here
    } catch (e) {
      // Handle errors if message sending fails
      // You can throw an error or return something indicating the failure
      throw e;
    }
  }

  void contactWithClients(BuildContext context, String sellerID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ContactClientsPage(), // Navigate to the ContactClientsPage
      ),
    );
  }

  Future<void> sendRequest(String sellerID, String productName, String condtion,
      String description, double listingPrice) async {
    String message =
        "I'm interested to buy $productName with the \nPrice $listingPrice SAR\nCondtion: $condtion\nDescription : $description\n  ";

    try {
      // Get the client ID
      String? clientId = await getUserId();
      if (clientId == null) {
        print("User ID not available.");
        return;
      }

      // Send request directly to the seller
      await _firestore.collection('requests').add({
        'sellerID': sellerID,
        'productName': productName,
        'listingPrice': listingPrice,
        'message': message,
        'clientId': clientId,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Failed to send request: $e');
      throw e;
    }
  }

  Future<void> sendResponse(
    String clientId,
    String sellerID,
    String productName,
    String responseMessage,
  ) async {
    try {
      // Send response to the client
      await FirebaseFirestore.instance.collection('responses').add({
        'clientId': clientId,
        'sellerID': sellerID,
        'productName': productName,
        'responseMessage': responseMessage,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Failed to send response: $e');
      throw e;
    }
  }
}
