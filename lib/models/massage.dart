import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverid;
  final String message;
  final Timestamp timestamp;
  final String senderFirstName;
  final String senderLastName;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverid,
    required this.message,
    required this.timestamp,
    required this.senderFirstName,
    required this.senderLastName,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverid': receiverid,
      'message': message,
      'timestamp': timestamp,
      'senderFirstName': senderFirstName,
      'senderLastName': senderLastName,
    };
  }
}
