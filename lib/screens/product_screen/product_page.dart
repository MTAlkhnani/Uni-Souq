import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unisouq/components/shimmer_deatil.dart';

import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';

import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:unisouq/screens/payment_page/payment_page.dart';
import 'package:unisouq/screens/product_screen/comment.dart';
import 'package:unisouq/utils/size_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../my_profile_page/my_profilepage.dart';

class ProductDetailPage extends StatefulWidget {
  static const String id = 'product_Detail';
  final String productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<DocumentSnapshot> _productFuture;
  late int _sellerRating = 0; // Set the seller's rating
  late int _numRatings = 0; // Set the number of ratings
  TextEditingController _commentController =
      TextEditingController(); // Controller for the comment input field
  late String _userName = ''; // Variable to hold the user's name
  bool _isLoading = false;
  bool _isItemSold = false;

  final ChatService _chatService = ChatService();
  late Map<String, dynamic> productData = {};

  bool _sendingInProgress = false; // State variable to track sending progress
  late bool _isRequestInProgress = false;
  List<Comment> comments = [];
  late User? _user;
  late Map<String, dynamic> _profileData = {};

  @override
  void initState() {
    super.initState();
    _fetchProductAndUser();
    _checkItemStatus();
    _checkRequestStatus(); // Call method to check request status
    _loadComments();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(user.uid)
          .get();

      if (mounted) {
        setState(() {
          _profileData = snapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  String getSellerUserID() {
    return productData['sellerID'];
  }

  Future<void> _checkRequestStatus() async {
    try {
      final currentUserUid = getCurrentUserUid();
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('ItemId', isEqualTo: widget.productId)
          .where('clientId', isEqualTo: currentUserUid)
          .get();

      setState(() {
        _isRequestInProgress = requestSnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking request status: $e');
    }
  }

  Future<void> _checkItemStatus() async {
    try {
      DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance
          .collection('Item')
          .doc(widget.productId)
          .get();

      if (itemSnapshot.exists) {
        setState(() {
          _isItemSold = itemSnapshot['status'] == 'Sold';
        });
      } else {
        setState(() {
          _isItemSold = false;
        });
      }
    } catch (e) {
      print('Error checking item status: $e');
    }
  }

  Future<void> _fetchProductAndUser() async {
    try {
      _productFuture = FirebaseFirestore.instance
          .collection('Item')
          .doc(widget.productId)
          .get();

      DocumentSnapshot productSnapshot = await _productFuture;

      if (!productSnapshot.exists) {
        setState(() {
          _userName = '';
        });
        return;
      }

      productData = productSnapshot.data()
          as Map<String, dynamic>; // Assign to class-level variable

      if (productData == null || !productData.containsKey('sellerID')) {
        setState(() {
          _userName = '';
        });
        return;
      }

      String userId = productData['sellerID'];

      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();

      setState(() {
        _userName = userSnapshot['FirstName'] + ' ' + userSnapshot['LastName'];
      });

      // Fetch the seller's rating
      await fetchSellerRating(userId);
    } catch (e) {
      print('Error fetching product and user data: $e');
    }
  }

  Future<void> fetchSellerRating(String sellerId) async {
    try {
      final QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
          .collection('Rating')
          .where('sellerId', isEqualTo: sellerId)
          .get();

      // Calculate the average rating
      if (ratingSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        _numRatings =
            ratingSnapshot.docs.length; // Update the number of ratings
        ratingSnapshot.docs.forEach((doc) {
          totalRating += doc['rating'] as double;
        });
        _sellerRating = (totalRating / _numRatings).toInt();
      }
    } catch (e) {
      print('Error fetching seller rating: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ProductDetail),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmerload();
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text(S.of(context).Productnotfound));
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
                  child: CarouselSlider.builder(
                    slideBuilder: (index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          imageUrl: imageURLs[index],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SpinKitWave(
                              color: Theme.of(context).primaryColor,
                              size: 50.0,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    },
                    viewportFraction: .99,
                    slideTransform: const CubeTransform(),
                    itemCount: imageURLs.length,
                    initialPage: 0,
                    enableAutoSlider: false,
                    autoSliderTransitionTime: const Duration(seconds: 2),
                    autoSliderDelay: const Duration(seconds: 2),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.v),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productData['title'] ?? '',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Seller's rating and share button
                                    _sellerRating != null
                                        ? Row(
                                            children: List.generate(
                                              5,
                                              (index) => Icon(
                                                Icons.star,
                                                color: index < _sellerRating!
                                                    ? Colors.orange
                                                    : Colors.grey[400],
                                              ),
                                            ),
                                          )
                                        : SizedBox(width: 8.v),
                                    Text(
                                      '($_numRatings)',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Display the discounted price if available
                          if (discountedPrice > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Now: ${discountedPrice.toStringAsFixed(0)} SAR",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .cardColor, // Display discounted price in red
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: () {
                                    // Implement share functionality
                                    final String productTitle =
                                        productData['title'] ?? 'No Title';
                                    final String productPrice =
                                        productData['price'].toString();
                                    final String shareContent =
                                        S.of(context).check;

                                    // Using the share package to share the content
                                    Share.share(shareContent);
                                  },
                                ),
                              ],
                            ),
                          // Display original price only if there is a discount
                          if (discountedPrice > 0)
                            Text(
                              "Before: ${price.toStringAsFixed(2)} SAR",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  color: Color.fromARGB(255, 207, 68, 58)),
                            ),
                          const SizedBox(height: 8),
                          // Product condition
                          Text(
                            "Condition: ${productData['condition']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          // Product description
                          Text(
                            productData['description'] ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Status : ${productData['status']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Container(child: _buildSellerProfileButton()),

                          const SizedBox(height: 16),
                          // Button to contact the seller or client
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    S.of(context).Comments,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),

                // Comment input field
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: S.of(context).write,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (isUserSignedIn()) {
                            _postComment();
                          } else {
                            _showSignInRequiredPopup(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Display comments
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.4, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      // Convert Firestore Timestamp to DateTime
                      DateTime dateTime = comments[index].timestamp.toDate();

                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            comments[index].avatar,
                            size: 40, // Adjust the icon size as needed
                          ),
                        ),
                        title: Text(comments[index].name),
                        subtitle: Text(comments[index].content),
                        trailing: Text(
                          // Format the DateTime object
                          DateFormat('yyyy-MM-dd').format(dateTime),
                          style: TextStyle(
                            fontSize: 12.h,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.h, vertical: 10.v),
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Item')
                    .doc(widget.productId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const SpinKitWave(
                      color: Colors.white,
                      size: 50.0,
                    );
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).disabledColor,
                        padding: EdgeInsets.symmetric(vertical: 10.v),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5.0), // Increase shape here
                        ),
                      ),
                      child: Text(
                        'Product Not Found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    );
                  }
                  final itemData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final sellerID = itemData['sellerID'];
                  if (sellerID == getCurrentUserUid()) {
                    return ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).disabledColor,
                        padding: EdgeInsets.symmetric(vertical: 10.v),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5.0), // Increase shape here
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sell,
                              color: Theme.of(context).dividerColor), // Icon
                          SizedBox(width: 5.v), // SizedBox for spacing
                          Text(
                            S.of(context).YouAreTheSeller,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Check if item is sold
                  if (_isItemSold) {
                    return ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).disabledColor,
                        padding: EdgeInsets.symmetric(vertical: 10.v),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5.0), // Increase shape here
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Theme.of(context).dividerColor), // Icon
                          SizedBox(width: 5.v), // SizedBox for spacing
                          Text(
                            S.of(context).Thisitemissold,
                            style: TextStyle(
                                fontSize: 18.h,
                                color: Theme.of(context).dividerColor),
                          ),
                        ],
                      ),
                    );
                  }

                  return ElevatedButton(
                    onPressed: _sendingInProgress ||
                            _isItemSold ||
                            _isRequestInProgress // Check if request is in progress
                        ? null
                        : () {
                            if (!isUserSignedIn()) {
                              // If user is not signed in, show the sign-in required pop-up
                              _showSignInRequiredPopup(context);
                            } else {
                              _showPriceInputDialog();
                            }
                          },
                    // if (!isUserSignedIn()) {
                    //   // If user is not signed in, show the sign-in required pop-up
                    //   _showSignInRequiredPopup(context);
                    // } else {
                    //   // If user is signed in, proceed to the AddProductScreen
                    //   Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(builder: (context) => AddProductScreen()),
                    //   );
                    // }
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 10.v),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // Increase shape here
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_checkout_sharp,
                            color: Theme.of(context).hintColor), // Icon
                        SizedBox(width: 5.v), // SizedBox for spacing
                        Text(
                          _sendingInProgress
                              ? S.of(context).InProgress
                              : _isRequestInProgress // Update button text based on request status
                                  ? S.of(context).RequestInProgress
                                  : S.of(context).RequestToBuy,
                          style: TextStyle(
                              fontSize: 18.h,
                              color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show the price input dialog
  void _showPriceInputDialog() {
    double currentPrice = double.parse(productData['price'] ?? '0');
    double currentDiscountedPrice =
        double.parse(productData['discountedPrice'] ?? '0');
    double price;

    if (currentDiscountedPrice > 0) {
      price = currentDiscountedPrice;
    } else {
      price = currentPrice;
    }

    // Convert dynamic list to List<String>
    List<String> imageUrlList = List<String>.from(productData['imageURLs']);

// Navigate to PaymentPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          sellerID: productData['sellerID'],
          productName: productData['title'],
          condition: productData['condition'],
          description: productData['description'],
          productId: widget.productId,
          currentPrice: price,
          imageUrl: imageUrlList, // Pass the converted list
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
          title: Text(S.of(context).SignInRequired),
          content: Text(S.of(context).maslog),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).Cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).SignIn),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                Navigator.pushNamed(context,
                    AppRoutes.signInScreen); // Navigate to Sign In Screen
              },
            ),
            TextButton(
              child: Text(S.of(context).SignUp),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                Navigator.pushNamed(context,
                    AppRoutes.signUpScreen); // Navigate to Registration Screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSellerProfileButton() {
    return Card(
      elevation: 3, // Card elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Card border radius
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // Navigate to the seller's profile screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                userId: getSellerUserID(),
              ),
            ),
          );
        },
        icon: Icon(Icons.person,
            color: Theme.of(context).hintColor), // Add icon here
        label: Text(
          S.of(context).ViewSellerProfile,
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).hintColor,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor, // Text color
          padding: EdgeInsets.symmetric(
            vertical: 15.v,
            horizontal: isArabic() ? 110.h : 90.h,
          ), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Button border radius
          ),
        ),
      ),
    );
  }

  void _postComment() async {
    if (_commentController.text.trim().isNotEmpty) {
      // Post the comment to Firestore
      await FirebaseFirestore.instance.collection('comments').add({
        'productId': widget.productId,
        'userName':
            '${_profileData['fName'] ?? ''} ${_profileData['lName'] ?? ''}',
        'comment': _commentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field
      _commentController.clear();

      // Reload comments after posting
      _loadComments();
    }
  }

  void _loadComments() {
    FirebaseFirestore.instance
        .collection('comments')
        .where('productId', isEqualTo: widget.productId)
        .get()
        .then((querySnapshot) {
      setState(() {
        comments = querySnapshot.docs.map((doc) {
          return Comment(
              avatar: Icons.person,
              name: doc['userName'],
              content: doc['comment'],
              timestamp: doc['timestamp']);
        }).toList();
      });
    }).catchError((error) {
      // Handle error
      print("Error loading comments: $error");
    });
  }

  bool isArabic() {
    return Intl.getCurrentLocale() == 'ar';
  }
}
