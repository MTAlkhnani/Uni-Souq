import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/utils/auth_utils.dart';

class MyOrderpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Orders'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Orders'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          String? clientId = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('My Orders'),
            ),
            body: ResponseList(
              currentUserId: clientId,
            ),
          );
        }
      },
    );
  }
}

class ResponseList extends StatelessWidget {
  final String? currentUserId; // Add a field to store the current user's ID

  ResponseList({required this.currentUserId});

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
            String itemId = response['itemId'];

            // Check if the current user is the client or the seller
            String clientId = response['clientId'];
            String sellerId = response['sellerID'];
            bool isClient = clientId == currentUserId;
            bool isSeller = sellerId == currentUserId;

            // Display the Card only if the current user is the client or the seller
            if (isClient || isSeller) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    _showItemDetail(context, itemId);
                  },
                  child: ListTile(
                    title: Text(responseMessage),
                  ),
                ),
              );
            } else {
              return SizedBox(); // Return an empty SizedBox if the current user is neither the client nor the seller
            }
          },
        );
      },
    );
  }

  void _showItemDetail(BuildContext context, String itemId) {
    // Implement _showItemDetail method as before
  }
}

void _showItemDetail(BuildContext context, String itemId) {
  FirebaseFirestore.instance
      .collection('Item')
      .doc(itemId)
      .get()
      .then((snapshot) {
    if (snapshot.exists) {
      // Extract item details from the snapshot and display them
      String title = snapshot['title'];
      double price = snapshot['price'];
      String description = snapshot['description'];

      // Show a dialog with the item details
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Price: $price'),
                Text('Description: $description'),
                // Add more item details here as needed
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      print('Item with ID $itemId does not exist');
    }
  }).catchError((error) {
    print('Error fetching item details: $error');
    // Handle errors if item details fetching fails
  });
}
