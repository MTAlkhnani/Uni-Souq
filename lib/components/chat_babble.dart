import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String massage;
  const ChatBubble({super.key, required this.massage});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).primaryColor),
        child: Text(
          massage,
          style: TextStyle(
              fontSize: 16, color: Theme.of(context).scaffoldBackgroundColor),
        ));
  }
}
