import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final String receiverUserId;
  final String message;

  const NotificationPage({
    required this.receiverUserId,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show a Snackbar with the received message and actions
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      message,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle accept action
                            _handleAccept(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Handle reject action
                            _handleReject(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: Text('Reject'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Text('Click to view notification'),
        ),
      ),
    );
  }

  void _handleAccept(BuildContext context) {
    // Handle accept action
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You accepted the request'),
        behavior: SnackBarBehavior.floating, // Centered SnackBar
      ),
    );
  }

  void _handleReject(BuildContext context) {
    // Handle reject action
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You rejected the request'),
        behavior: SnackBarBehavior.floating, // Centered SnackBar
      ),
    );
  }
}
