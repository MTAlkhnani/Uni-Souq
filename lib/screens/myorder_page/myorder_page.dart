import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
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
                title: const Text('My Orders'),
              ),
              body: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 170.h, vertical: 10.v),
                child: const SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ),
                ),
              ));
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Orders'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          String? clientId = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Orders'),
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
  String? selectedItemId;

  ResponseList({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('responses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 170.h, vertical: 10.v),
            child: const SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 4.0,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<DocumentSnapshot> responseDocs = snapshot.data!.docs;

        if (responseDocs.isEmpty) {
          return const Center(child: Text('No notifications'));
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
                  if (itemSnapshot.connectionState ==
                      ConnectionState.waiting) {}
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
                          await _showAcceptedOrderDetail(context,
                              response['responseMessage'], sellerID, clientId);
                        } else if (status == 'rejected') {
                          _showRejectedOrderDetail(
                              context, response['responseMessage'], sellerID);
                        }
                      },
                      child: ListTile(
                        leading: imageURL.isNotEmpty
                            ? Image.network(imageURL)
                            : const SizedBox(), // Display imageURL if available
                        title: Text('Product: $title'),
                        subtitle: Text(
                            'Seller ID: $sellerID, \nTitle: $title'), // Display sellerID and title as the subtitle
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

  _showAcceptedOrderDetail(BuildContext context, String responseMessage,
      String sellerId, String clientId) async {
    try {
      bool _isClient = false; // Track if the current user is the client
      bool _isRated = false; // Track if the client has already rated the seller
      double _rating = 0; // Variable to store the rating

      String getCurrentUserUid() {
        final User? user = FirebaseAuth.instance.currentUser;
        final String uid = user?.uid ?? "Not Signed In";
        return uid;
      }

      // Check if the current user is the client
      if (clientId == getCurrentUserUid()) {
        _isClient = true;

        // Retrieve the rating from Firestore
        var snapshot = await FirebaseFirestore.instance
            .collection('Rating')
            .doc(sellerId)
            .get();

        if (snapshot.exists) {
          // If a rating exists, set it as the initial value of _rating
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          if (data['clientId'] == clientId) {
            _rating = data['rating'];
            _isRated = true;
          }
        }
      } else {
        // If the current user is not the client, fetch the rating for the seller
        var sellerSnapshot = await FirebaseFirestore.instance
            .collection('Rating')
            .doc(sellerId)
            .get();

        if (sellerSnapshot.exists) {
          // If a rating exists for the seller, set it as the initial value of _rating
          Map<String, dynamic> sellerData =
              sellerSnapshot.data() as Map<String, dynamic>;
          _rating = sellerData['rating'];
          _isRated = true;
        }
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Order Details'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(responseMessage),
                    // Button to show rating options (visible only to the client)
                    Visibility(
                      visible: _isClient,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isRated = !_isRated;
                          });
                        },
                        child: Text(_isRated ? 'Hide Rating' : 'Rate Seller'),
                      ),
                    ),
                    // Rating bar (visible to everyone)
                    Visibility(
                      visible: _isRated,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text('Seller Rating'),
                          RatingBar.builder(
                            initialRating: _rating, // Set initial rating
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible:
                                _isClient, // Only show the submit button if the user is a client
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle submitting the rating
                                if (_rating > 0) {
                                  try {
                                    // Update Firestore with the rating
                                    FirebaseFirestore.instance
                                        .collection('Rating')
                                        .doc(sellerId)
                                        .set({
                                      'sellerId': sellerId,
                                      'clientId': clientId,
                                      'rating': _rating,
                                      'timestamp': DateTime.now(),
                                    }).then((value) {
                                      print('Rating submitted successfully');
                                      Navigator.pop(
                                          context); // Close the dialog
                                    }).catchError((error) {
                                      print('Failed to submit rating: $error');
                                      // Handle error if rating submission fails
                                    });
                                  } catch (error) {
                                    print('Error submitting rating: $error');
                                  }
                                } else {
                                  // Show an error message if the rating is not selected
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please select a rating before submitting.'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton.icon(
                    onPressed: () {
                      final ChatService chatService = ChatService();
                      // Generate product issue message
                      String productIssueMessage =
                          'Hello, \nI have a problem with the product that I purchased from you';
                      // Handle Product Issue button press
                      chatService.contactSellerproblem(
                        context,
                        sellerId,
                        productIssueMessage,
                      );
                    },
                    icon: const Icon(Icons.report),
                    label: Text(
                      'Product Issue',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Color.fromARGB(255, 184, 31, 20),
                    ),
                    label: const Text(
                      'Back',
                      style: TextStyle(
                        color: Color.fromARGB(255, 184, 31, 20),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
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
          title: const Text('Rejected Order Details'),
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
                'Close',
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
                'Contact Seller',
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
