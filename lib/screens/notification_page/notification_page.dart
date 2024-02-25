import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final String senderName;
  final String message;

  NotificationPage({required this.senderName, required this.message});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    // Add the received notification to the list when the page initializes
    notifications.add('${widget.senderName}: ${widget.message}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
