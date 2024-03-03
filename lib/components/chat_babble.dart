import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String? imageUrl;
  final bool isSender; // Add isSender field
  final String messageSentTime; // Add messageSentTime field

  const ChatBubble({
    Key? key,
    required this.message,
    this.imageUrl,
    required this.isSender,
    required this.messageSentTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bubbleColor = isSender
        ? Color.fromARGB(255, 181, 100, 228)! // Sender's bubble color
        : Colors.grey[300]!; // Receiver's bubble color

    final Color textColor = isSender
        ? Theme.of(context).scaffoldBackgroundColor // Sender's text color
        : Colors.black; // Receiver's text color

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: bubbleColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl != null
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
                    color: textColor,
                  ),
                ),
          const SizedBox(height: 4), // Add spacing between message and time
          Text(
            messageSentTime,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.6), // Adjust opacity as needed
            ),
          ),
        ],
      ),
    );
  }
}
