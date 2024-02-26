import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ResponseList(),
    );
  }
}

class ResponseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('responses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<DocumentSnapshot> responseDocs = snapshot.data!.docs;

        if (responseDocs.isEmpty) {
          return Center(child: Text('No notifications'));
        }

        return ListView.builder(
          itemCount: responseDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot response = responseDocs[index];
            String responseMessage = response['responseMessage'];
            // You can display additional information from the response if needed

            return ListTile(
              title: Text(responseMessage),
              // Add more ListTile properties or customize UI as needed
            );
          },
        );
      },
    );
  }
}
