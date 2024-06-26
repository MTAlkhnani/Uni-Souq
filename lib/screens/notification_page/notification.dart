import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';

class NotificationPage extends StatelessWidget {
  final String userId;

  NotificationPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    // Mark all notifications as read
    FirebaseFirestore.instance
        .collection('Notification')
        .doc(userId)
        .collection('UserNotifications')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.update({'read': true});
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Notifications),
        actions: [
          GestureDetector(
            onTap: () {
              // Implement clear all functionality
              FirebaseFirestore.instance
                  .collection('Notification')
                  .doc(userId)
                  .collection('UserNotifications')
                  .get()
                  .then((snapshot) {
                for (DocumentSnapshot doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.clear_all),
                  const SizedBox(width: 4),
                  Text(S.of(context).ClearAll),
                ],
              ),
            ),
          ),
        ],
      ),
      body: NotificationList(userId: userId),
    );
  }
}

class NotificationList extends StatelessWidget {
  final String userId;

  NotificationList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Notification')
          .doc(userId)
          .collection('UserNotifications')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitWave(
            color: Colors.white,
            size: 50.0,
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<DocumentSnapshot> notifications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var notification = notifications[index];

            return NotificationItem(
              title: notification['title'],
              body: notification['body'],
              type: notification['notificationType'],
            );
          },
        );
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String type;

  NotificationItem({
    required this.title,
    required this.body,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications), // Add leading icon here
        title: Text(title),
        subtitle: Text(body),
        onTap: () {
          switch (type) {
            case 'message':
              // Navigate to MessagingPage with receiverUserID
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MessagingPage(
                    receiverUserID:
                        title, // Assuming you have receiverUserID defined
                  ),
                ),
              );
              break;
            case 'request':
              // Handle request notification
              Navigator.of(context).pushNamed(AppRoutes
                  .requestpage); // Assuming you have named routes set up
              break;
            case 'responses':
              Navigator.of(context).pushNamed(AppRoutes
                  .myorderpage); // Assuming you have named routes set up
              break;
            default:
              // Handle unknown notification type or do nothing
              break;
          }
        },
      ),
    );
  }
}
