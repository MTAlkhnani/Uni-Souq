import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/edit_product_screen/edit_product.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';

import 'package:unisouq/utils/size_utils.dart';

class ProductDetailPage extends StatefulWidget {
  static const String id = 'product_Detail';
  final String productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<DocumentSnapshot> _productFuture;
  int _sellerRating = 4; // Set the seller's rating
  int _numRatings = 150; // Set the number of ratings
  TextEditingController _commentController =
      TextEditingController(); // Controller for the comment input field
  late String _userName = ''; // Variable to hold the user's name
  bool _isLoading = false;

  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _fetchProductAndUser();
  }

  Future<void> _fetchProductAndUser() async {
    try {
      // Initialize _productFuture with the result of the Firestore query
      _productFuture = FirebaseFirestore.instance
          .collection('Item')
          .doc(widget.productId)
          .get();

      // Fetch the product document
      DocumentSnapshot productSnapshot = await _productFuture;

      // Check if the document exists
      if (!productSnapshot.exists) {
        // Handle the case where the product document does not exist
        setState(() {
          // Set _userName to a default value or an empty string
          _userName = ''; // or any other default value
        });
        return; // Exit the method early
      }

      // Get the data as a map
      Map<String, dynamic> productData =
          productSnapshot.data() as Map<String, dynamic>;

      // Check if the data is null or if the map does not contain the key "userId"
      if (productData == null || !productData.containsKey('userId')) {
        // Handle the case where the "userId" field does not exist
        setState(() {
          // Set _userName to a default value or an empty string
          _userName = ''; // or any other default value
        });
        return; // Exit the method early
      }

      // Retrieve the user ID
      String userId = productData['userId'];

      // Query Firestore to get the user's information based on the user ID
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      // Extract the user's name from the user snapshot
      setState(() {
        _userName = userSnapshot['FirstName'] + ' ' + userSnapshot['LastName'];
      });
    } catch (e) {
      // Handle errors
      print('Error fetching product and user data: $e');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Product not found'));
          }
          // Extract product data
          final productData = snapshot.data!.data() as Map<String, dynamic>;
          List<String> imageURLs = List<String>.from(productData['imageURLs']);

          // Calculate the discounted price if available
          double price = double.parse(productData['price'] ?? '0');
          double discountedPrice =
              double.parse(productData['discountedPrice'] ?? '0');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product images slider
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageURLs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context)
                            .size
                            .width, // Full width of the screen
                        child: CachedNetworkImage(
                          imageUrl: imageURLs[index],
                          fit: BoxFit.cover, // Fill the container
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product title
                        Text(
                          productData['title'] ?? '',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        // Display the discounted price if available
                        if (discountedPrice > 0)
                          Text(
                            'Now: ${discountedPrice.toStringAsFixed(0)} SAR',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .cardColor, // Display discounted price in red
                            ),
                          ),
                        // Display original price only if there is a discount
                        if (discountedPrice > 0)
                          Text(
                            'Before: ${price.toStringAsFixed(2)} SAR',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough,
                                color: Color.fromARGB(255, 207, 68, 58)),
                          ),
                        const SizedBox(height: 8),
                        // Product condition
                        Text(
                          'Condition: ${productData['condition']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Product description
                        Text(
                          productData['description'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        // Seller's rating and share button
                        Row(
                          children: [
                            const Text(
                              'Seller Rating: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: index < _sellerRating
                                      ? Colors.orange
                                      : Colors.grey[400],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '($_numRatings)',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(), // Adds space between the rating and the share button
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {
                                // Implement share functionality
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Button to contact the seller or client
                        // Button to contact the seller or client
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Builder(
                            builder: (context) {
                              final currentUserUid = getCurrentUserUid();
                              final sellerId = productData['sellerID'];

                              if (currentUserUid == sellerId) {
                                // Render both buttons in a row if the current user is the seller
                                return Row(
                                  children: [
                                    // Add spacing between buttons
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if(isUserSignedIn()){
                                          // Implement logic to contact the clients
                                          _chatService.contactWithClients(
                                              context, sellerId);
                                        }
                                        else{
                                          _showSignInRequiredPopup(context);
                                        }

                                      },
                                      icon: const Icon(Icons.message),
                                      label: const Text('Contact the Clients'),
                                      style: ElevatedButton.styleFrom(),
                                    ),
                                    SizedBox(width: 50.v),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        if(isUserSignedIn()){
                                          // Implement logic to edit the product
                                          // Navigate to the edit product screen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProductScreen(
                                                    productData: productData,
                                                  ),
                                            ),
                                          );
                                        }
                                        else{
                                          _showSignInRequiredPopup(context);
                                        }

                                      },
                                    ),
                                  ],
                                );
                              } else {
                                // Render the contact button if the current user is not the seller
                                return ElevatedButton.icon(
                                  onPressed: () {
                                    if(isUserSignedIn()){
                                      // Implement logic to contact the seller
                                      _chatService.contactSeller(
                                          context, sellerId);
                                    }
                                    else{
                                      _showSignInRequiredPopup(context);
                                    }

                                  },
                                  icon: const Icon(Icons.message),
                                  label: const Text('Contact the Seller'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 77, 139, 79),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    'Comments',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),

                // Comments list view
                // Expanded(
                //   child: StreamBuilder<QuerySnapshot>(
                //     stream: FirebaseFirestore.instance
                //         .collection('comments') // Assuming 'comments' is your collection name
                //         .where('productId', isEqualTo: widget.productId)
                //         .snapshots(),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return Center(child: CircularProgressIndicator());
                //       }
                //       if (snapshot.hasError) {
                //         return Center(child: Text('Error: ${snapshot.error}'));
                //       }
                //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                //         return Center(child: Text('No comments yet'));
                //       }
                //
                //       return ListView(
                //         children: snapshot.data!.docs.map((doc) {
                //           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                //           return ListTile(
                //             title: Text(data['userName']),
                //             subtitle: Text(data['comment']),
                //           );
                //         }).toList(),
                //       );
                //     },
                //   ),
                // ),

                // Comment input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (isUserSignedIn()) {
                            //_postComment();
                          } else {
                            _showSignInRequiredPopup(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {
              if (!isUserSignedIn()) {
              // If user is not signed in, show the sign-in required pop-up
              _showSignInRequiredPopup(context);
              } else {

              }
              // Implement logic to buy the product
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context)
                  .primaryColor, // Change the background color here
            ),
            child: Text(
              'Checkout',
              style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).scaffoldBackgroundColor),
            ),
          ),
        ),
      ),
    );
  }

  String getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? "Not Signed In";
    return uid;
  }
  bool isUserSignedIn() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  void _showSignInRequiredPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sign In Required"),
          content: Text("Please sign in or sign up to access this feature."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sign In"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                Navigator.pushNamed(context, AppRoutes.signInScreen); // Navigate to Sign In Screen
              },
            ),
            TextButton(
              child: Text("Sign Up"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                Navigator.pushNamed(context, AppRoutes.signUpScreen); // Navigate to Registration Screen
              },
            ),
          ],
        );
      },
    );
  }

  void _postComment() {
    if (_commentController.text.trim().isNotEmpty) {
      // Post the comment to Firestore
      FirebaseFirestore.instance.collection('comments').add({
        'productId': widget.productId,
        'userName': _userName,
        'comment': _commentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field
      _commentController.clear();
    }
  }


}
