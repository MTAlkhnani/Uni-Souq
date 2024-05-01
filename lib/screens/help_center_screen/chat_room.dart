import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/auth_utils.dart';

// Define the User class
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = []; // List to store chat messages
  bool _askedInitialQuestion = false;
  bool _askedForDescription =
      false; // Flag to track if bot has asked for description
  User? _user; // User object to store user details

  @override
  void initState() {
    super.initState();
    // Fetch user details when the chat room screen is first loaded
    _fetchUserDetails();
    // Bot sends the first message
    _sendFirstMessage();
  }

  // Method to fetch user details using Firebase Authentication
  void _fetchUserDetails() async {
    String? userId = await getUserId();
    if (userId != null) {
      // Get the user document from Firestore
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();
      // Extract user data from the document
      var userData = userSnapshot.data() as Map<String, dynamic>;
      String name = userData['FirstName'] + " " + userData['LastName'];
      String email = userData['Email'];
      // Create a User object
      setState(() {
        _user = User(name: name, email: email);
      });
    }
  }

  void _sendFirstMessage() {
    // Simulate bot initiating the conversation with a question
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add('${'Bot'}: Hello! How can I assist you today?');
        _askedInitialQuestion =
            true; // Set flag to true after asking the initial question
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Support'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUserMessage = _messages[index].startsWith('You:');
                return _buildMessageBubble(_messages[index], isUserMessage);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isUserMessage) {
    final alignment =
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color =
        isUserMessage ? Theme.of(context).primaryColor : Colors.blueGrey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: alignment,
        children: [
          Flexible(
            // Wrap the text widget in Flexible
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(12),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _messages.add('You: $message'); // Add user's message to the chat
      });
      // If the initial question has been asked, respond to user's message
      if (_askedInitialQuestion) {
        _respondToUserMessage(message);
      }
      _messageController
          .clear(); // Clear the text field after sending the message
    }
  }

  void _respondToUserMessage(String message) {
    // Simulate bot responses
    Future.delayed(const Duration(seconds: 1), () {
      String botResponse;
      if (message.toLowerCase().contains('hi') ||
          message.toLowerCase().contains('hello')) {
        botResponse =
            'I am just a bot, but I am here to help you. How can I assist you today?';
      } else {
        // Check if the initial question has been asked
        if (_askedInitialQuestion) {
          // Check if the bot has already asked for a detailed description
          if (!_askedForDescription) {
            botResponse =
                'Our service will be with you shortly. Can you provide us with a detailed description of the issue you are facing while waiting for the service to join?';
            _askedForDescription =
                true; // Set the flag to true after asking for description
          } else {
            botResponse = ''; // Empty response if already asked for description
          }
        } else {
          // If the initial question hasn't been asked yet, ask it first
          botResponse =
              'Hello! How can I assist you today?'; // Ask the initial question
          _askedInitialQuestion =
              true; // Set the flag to true after asking the initial question
        }
      }
      setState(() {
        if (botResponse.isNotEmpty) {
          _messages.add('Bot: $botResponse'); // Add bot's response to the chat
        }
      });
      // Save the user's message and details to Firestore
      if (_user != null) {
        saveMessageToSupportCollection(message, _user!);
      }
    });
  }
}

// Method to save message and user details to Firestore
void saveMessageToSupportCollection(String message, User user) {
  // Add the message document to the "support" collection
  FirebaseFirestore.instance.collection('support').add({
    'message': message,
    'user_name': user.name,
    'user_email': user.email,
    'timestamp': FieldValue.serverTimestamp(),
  }).then((value) {
    print('Message saved to Firestore: $message, User: ${user.name}');
  }).catchError((error) {
    print('Failed to save message: $error');
  });
}
