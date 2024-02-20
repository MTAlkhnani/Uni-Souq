import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/components/chat_babble.dart';
import 'package:unisouq/components/my_text_field.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';

class MessagingPage extends StatefulWidget {
  static const String id = 'massaging_page';

  final String reciverUserID;

  MessagingPage({super.key, required this.reciverUserID});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final TextEditingController _controller = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // final CollectionReference _messages =
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _chatService.sendMessage(widget.reciverUserID, _controller.text);

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with The Seller"),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: _buildMassgeInput(),
          )
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.reciverUserID, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMassgeItem(document))
                .toList(),
          );
        });
  }

  Widget _buildMassgeItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    var alignment = (data['senderID'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerLeft
        : Alignment.centerRight;

    String senderName = '${data['senderFirstName']} ${data['senderLastName']}';

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              ((data['senderID'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end),
          mainAxisAlignment:
              ((data['senderID'] == _firebaseAuth.currentUser!.uid)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start),
          children: [
            Text(senderName),
            const SizedBox(height: 6),
            ChatBubble(
              massage: data['message'],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMassgeInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextField(
          controller: _controller,
          hintText: 'Enter massage',
          keyboardType: TextInputType.text,
          obscureText: false,
        )),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_forward,
              size: 40,
            ))
      ],
    );
  }
}
