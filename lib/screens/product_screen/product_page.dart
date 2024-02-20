import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unisouq/screens/edit_product_screen/edit_product.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import 'package:unisouq/screens/product_screen/comment.dart';
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
  List<Comment> comments = [];
  @override
  void initState() {
    super.initState();
    _fetchProductAndUser();
    _fetchComments();
  }

  Future<List<Comment>> _fetchComments() async {
    try {
      // Query Firestore to get the comments associated with the product
      QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('productId', isEqualTo: widget.productId)
          .get();

      // Extract comments data
      List<Comment> fetchedComments = commentsSnapshot.docs.map((commentDoc) {
        Map<String, dynamic> commentData =
            commentDoc.data() as Map<String, dynamic>;
        return Comment(
          avatar: commentData['avatar'],
          name: commentData['name'],
          Content: commentData['Content'],
        );
      }).toList();

      return fetchedComments;
    } catch (e) {
      // Handle errors
      print('Error fetching comments: $e');
      // Return an empty list in case of error
      return [];
    }
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

          // Fetch comments data
          List<Comment> comments = [];

          if (productData.containsKey('comments') &&
              productData['comments'] != null) {
            comments =
                List<Comment>.from(productData['comments'].map((commentData) {
              return Comment(
                avatar: commentData['avatar'],
                name: commentData['name'],
                Content: commentData['text'],
              );
            }));
          }

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
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    final currentUserUid = getCurrentUserUid();
                                    final sellerId = productData['sellerID'];
                                    final productId = productData['sellerID'];

                                    if (currentUserUid == sellerId) {
                                      // Render the edit button if the current user is the seller
                                      return IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
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
                                        },
                                      );
                                    } else {
                                      // Render the contact button if the current user is not the seller
                                      return ElevatedButton.icon(
                                        onPressed: () {
                                          // Implement logic to contact the client
                                          _chatService.contactSeller(
                                              context, sellerId);
                                        },
                                        icon: Icon(Icons.message),
                                        label: Text('Contact the Seller'),
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 77, 139, 79),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Comment section

                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                            ), // Add border for separation
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Comments', // Section title
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height:
                                    200, // Set a fixed height or adjust as needed
                                child: FutureBuilder<List<Comment>>(
                                  future: _fetchComments(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const Center(
                                          child: Text('No comments available'));
                                    }
                                    // Comments data is available
                                    List<Comment> comments = snapshot.data!;
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: comments.length,
                                            itemBuilder: (context, index) {
                                              final comment = comments[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage:
                                                          AssetImage(
                                                        comment.avatar
                                                                .isNotEmpty
                                                            ? comment.avatar
                                                            : 'assets/images/profile_Defulat.jpg',
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          comment
                                                              .name, // Display user's name
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10.h),
                                                        Text(
                                                          comment
                                                              .Content, // Display the comment content
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Comment input field
                              TextFormField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                  hintText: 'Add a comment...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Submit button
                              ElevatedButton(
                                onPressed: _submitComment,
                                child: const Text('Comment'),
                              ),
                            ],
                          ),
                        ),
                      ]),
                )
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
              // Implement logic to buy the product
            },
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context)
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

  // Method to submit a comment
  Future<void> _submitComment() async {
    if (_commentController.text.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        // Retrieve ItemID and UserID
        String itemId = widget.productId;
        String userId = getCurrentUserUid();

        // Add the comment to the Comment collection
        await FirebaseFirestore.instance.collection('Comment').add({
          'Content': _commentController.text,
          'ItemID': itemId,
          'UserID': userId,
        });

        // Update the local comments list with the new comment
        setState(() {
          comments.add(Comment(
            avatar:
                'assets/images/profile_Defulat.jpg', // Add the necessary avatar path here
            name: _userName, // Use the current user's name
            Content: _commentController.text,
          ));

          // Clear the comment input field
          _commentController.clear();
        });
      } catch (e) {
        // Handle errors
        print('Error adding comment: $e');
      }
      setState(() => _isLoading = false);
    }
  }

  String getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? "Not Signed In";
    return uid;
  }
}
