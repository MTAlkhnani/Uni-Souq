import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String senderID;
  late String senderEmail;
  late String receiverId;
  late String message;
  late Timestamp timestamp;
  late String senderFirstName;
  late String senderLastName;
  late String receiverFirstName;
  late String receiverLastName;
  late String? imageUrl;

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
