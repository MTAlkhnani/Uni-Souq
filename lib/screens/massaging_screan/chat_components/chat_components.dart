// chat_components.dart
import 'package:flutter/material.dart';

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
