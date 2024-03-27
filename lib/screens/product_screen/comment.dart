import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  final IconData avatar;
  final String name;
  final String content;
  final Timestamp timestamp;

  Comment({
    required this.timestamp,
    required this.avatar,
    required this.name,
    required this.content,
  });
}
