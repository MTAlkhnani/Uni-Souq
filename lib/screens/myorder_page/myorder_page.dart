import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:unisouq/screens/order_information/oreder_deatil.dart';
import 'package:unisouq/utils/auth_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:unisouq/utils/size_utils.dart';

class MyOrderpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).MyOrders),
              ),
              body: const SpinKitWave(
                color: Colors.white,
                size: 50.0,
              ));
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).MyOrders),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          String? clientId = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).MyOrders),
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
  final String? currentUserId;
  late String? selectedItemId;

  ResponseList({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('responses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitWave(
            color: Colors.white,
            size: 50.0,
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<DocumentSnapshot> responseDocs = snapshot.data!.docs;

        if (responseDocs.isEmpty) {
          return Center(child: Text(S.of(context).Nonotifications));
        }

        return ListView.builder(
          itemCount: responseDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot response = responseDocs[index];
            String itemId = response['itemId'];
            selectedItemId = itemId;
            String status =
                response['status']; // Add a field for order status in Firestore

            // Check if the current user is the client or the seller
            String clientId = response['clientId'];
            String sellerId = response['sellerID'];
            bool isClient = clientId == currentUserId;
            bool isSeller = sellerId == currentUserId;

            // Display the Card only if the current user is the client or the seller
            if (isClient || isSeller) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Item')
                    .doc(itemId)
                    .get(),
                builder: (context, itemSnapshot) {
                  if (itemSnapshot.connectionState == ConnectionState.waiting) {
                    const SpinKitWave(
                      color: Colors.white,
                      size: 50.0,
                    );
                  }
                  if (itemSnapshot.hasError || !itemSnapshot.hasData) {
                    return const SizedBox(); // Return empty SizedBox if item snapshot has error or no data
                  }

                  String sellerID = itemSnapshot.data!['sellerID'];

                  String title = itemSnapshot.data!['title'];
                  List<String> imageURLs = List<String>.from(
                      itemSnapshot.data!['imageURLs'] ??
                          []); // Retrieve imageURLs list from Item document
                  String imageURL = imageURLs.isNotEmpty
                      ? imageURLs.first
                      : ''; // Get the first imageURL if available

                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: GestureDetector(
                      onTap: () async {
                        if (status == 'accepted') {
                          _showAcceptedOrderDetail(
                              context,
                              response['responseMessage'],
                              sellerID,
                              clientId,
                              itemId,
                              imageURL,
                              title);
                        } else if (status == 'rejected') {
                          _showRejectedOrderDetail(
                              context, response['responseMessage'], sellerID);
                        }
                      },
                      child: ListTile(
                        leading: imageURL.isNotEmpty
                            ? Image.network(imageURL)
                            : const SizedBox(), // Display imageURL if available
                        title: Text("Product: $title"),
                        subtitle: Text(
                            "Seller ID: $sellerID, \nTitle: $title "), // Display sellerID and title as the subtitle
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }

  void _showAcceptedOrderDetail(
    BuildContext context,
    String responseMessage,
    String sellerId,
    String clientId,
    String itemId, // Pass itemId directly
    String imageURL,
    String title,
  ) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailsPage(
            responseMessage: responseMessage,
            itemId: itemId, // Use the passed itemId
            imageURL: imageURL,
            title: title,
            clientId: clientId,
            sellerId: sellerId,
          ),
        ),
      );
    } catch (error) {
      print('Error showing order details: $error');
    }
  }

  void _showRejectedOrderDetail(
      BuildContext context, String responseMessage, String sellerId) {
    // Handle displaying rejected order details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).RejectedOrderDetails),
          content: Text(responseMessage),
          actions: [
            TextButton.icon(
              onPressed: () {
                // Close the dialog
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Color.fromARGB(255, 184, 31, 20),
              ),
              label: Text(
                S.of(context).Close,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
            const SizedBox(width: 8), // Add spacing between buttons
            TextButton.icon(
              onPressed: () {
                // Handle contacting the seller
                final ChatService chatService = ChatService();
                chatService.contactSeller(context, sellerId);
              },
              icon: const Icon(
                Icons.chat,
                color: Color.fromARGB(255, 43, 168, 48),
              ),
              label: Text(
                S.of(context).ContactSeller,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
          ],
        );
      },
    );
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
                child: const Text('Close'),
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
