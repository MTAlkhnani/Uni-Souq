import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:unisouq/utils/auth_utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
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

  ResponseList({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('responses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                    return const CircularProgressIndicator();
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
                      onTap: () {
                        _showItemDetail(context, response['responseMessage'],
                            sellerID, clientId);
                      },
                      child: ListTile(
                        leading: imageURL.isNotEmpty
                            ? Image.network(imageURL)
                            : const SizedBox(), // Display imageURL if available
                        title: Text('Product: $title'),
                        subtitle: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('User')
                              .doc(sellerID)
                              .get(),
                          builder: (context, sellerSnapshot) {
                            if (sellerSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }
                            if (sellerSnapshot.hasError ||
                                !sellerSnapshot.hasData) {
                              return const Text('Seller: Unknown');
                            }
                            String firstName =
                                sellerSnapshot.data!['FirstName'];
                            String lastName = sellerSnapshot.data!['LastName'];
                            return Text(
                                'Seller: $firstName $lastName, \nTitle: $title');
                          },
                        ),
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

  void _showItemDetail(BuildContext context, String responseMessage,
      String sellerId, String clientId) {
    double _rating = 0;
    double _currentRating = 0; // Variable to store the current rating
    bool _isRated =
        false; // Variable to track if the client has already rated the seller

    // Check if the client has already rated the seller
    FirebaseFirestore.instance
        .collection('Rating')
        .doc(sellerId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        // If rating exists, get the current rating
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data['clientId'] == clientId) {
          _currentRating = data['rating'];
          _isRated = true;
          _rating = _currentRating; // Set the initial rating
          // Rebuild the dialog to display the rating
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Recipe Details'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(responseMessage),
                        const SizedBox(height: 20),
                        const Text('Rate Seller'),
                        const SizedBox(height: 10),
                        _isRated
                            ? RatingBar.builder(
                                initialRating: _currentRating,
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
                                // Disable the RatingBar if the client has already rated the seller
                                tapOnlyMode: true,
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                              )
                            : RatingBar.builder(
                                initialRating: _rating,
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
                      ],
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: _isRated
                                ? null
                                : () {
                                    // Handle Rate the Seller button press
                                    // Update Firestore with the rating
                                    FirebaseFirestore.instance
                                        .collection('Rating')
                                        .doc(sellerId)
                                        .set({
                                      'sellerId': sellerId,
                                      'clientId':
                                          clientId, // Include clientId in the document
                                      'rating': _rating
                                    }).then((value) {
                                      // Update _currentRating when the rating is submitted
                                      _currentRating = _rating;
                                      _isRated = true;
                                      Navigator.pop(context);
                                    }).catchError((error) => print(
                                            "Failed to add rating: $error"));
                                  },
                            icon: const Icon(Icons.star),
                            label: const Text('Submit'),
                            // Disable the button if the client has already rated the seller
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith(
                                  (states) => _isRated
                                      ? Colors.transparent
                                      : Colors.blue.withOpacity(0.1)),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              final ChatService chatService = ChatService();
                              // Generate product issue message
                              String productIssueMessage =
                                  'Hello ,\ni have problem with \nProduct that i purchased from you ';
                              // Handle Product Issue button press
                              chatService.contactSellerproblem(
                                context,
                                sellerId,
                                productIssueMessage,
                              );
                            },
                            icon: const Icon(Icons.report),
                            label: const Text('Product Issue'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          );
        }
      }
    }).catchError((error) {
      print('Error checking rating: $error');
    });
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
