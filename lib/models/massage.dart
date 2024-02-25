import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;

  final String receiverId;

  final String message;
  final Timestamp timestamp;
  final String senderFirstName;
  final String senderLastName;
  final String receiverFirstName;
  final String receiverLastName;
  final String? imageUrl;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.senderFirstName,
    required this.senderLastName,
    required this.receiverFirstName,
    required this.receiverLastName,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'senderFirstName': senderFirstName,
      'senderLastName': senderLastName,
      'receiverFirstName': receiverFirstName,
      'receiverLastName': receiverLastName,
      'imageUrl': imageUrl,
    };
  }
}
