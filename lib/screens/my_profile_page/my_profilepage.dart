import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/screens/information_screen/information_screen.dart';
import 'package:unisouq/screens/product_screen/product_page.dart';

class ProfilePage extends StatefulWidget {
  final String userId; // Accept userId as a parameter

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userName = '';
  late String imageUrl = '';
  late int phone = 0;
  late String university = '';
  double sellerRating = 0.0; // Variable to store seller's rating
  int numRatings = 0; // Variable to store the number of ratings

  late String currentUserId; // Variable to store the current user's ID

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchSellerRating(); // Fetch the seller's rating when the page initializes
    getCurrentUserId(); // Get the current user's ID
  }

  Future<void> getCurrentUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  Future<void> fetchUserData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Profile')
        .doc(widget.userId) // Use the userId passed from the constructor
        .get();

    setState(() {
      userName = userDoc['fName'] + " " + userDoc['lName'];
      imageUrl = userDoc['userImage'];
      phone = userDoc['phone'];
      university = userDoc['university'];
    });
  }

  Future<void> fetchSellerRating() async {
    try {
      final QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
          .collection('Rating')
          .where('sellerId', isEqualTo: widget.userId)
          .get();

      // Calculate the average rating
      if (ratingSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        numRatings = ratingSnapshot.docs.length; // Update the number of ratings
        for (var doc in ratingSnapshot.docs) {
          totalRating += doc['rating'] as double;
        }
        sellerRating = totalRating / numRatings;

        // Check if the widget is mounted before calling setState
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error fetching seller rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Profile),
        actions: [
          if (currentUserId ==
              widget
                  .userId) // Display edit button if it's the current user's profile
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // Navigate to the edit profile page
                // You can implement the navigation logic here
                final newIndex = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformationScreen(
                        userId: FirebaseAuth.instance.currentUser!.uid),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildDefaultProfileImage(),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Phone: $phone",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 20),
            Text(
              university,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).Rating,
                  style: const TextStyle(fontSize: 16),
                ),
                RatingBar.builder(
                  initialRating: sellerRating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              " Number of Ratings: $numRatings",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).Collection,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Item')
                  .where('sellerID', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final List<DocumentSnapshot> items = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final itemData =
                        items[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Item')
                                  .doc(items[index].id)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // return const CircularProgressIndicator();
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Text('Document does not exist');
                                }
                                final itemData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                // Now we have the correct itemData, navigate to ProductDetailPage
                                return ProductDetailPage(
                                    productId: items[index].id);
                              },
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shadowColor: Theme.of(context).primaryColor,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Theme.of(context).hintColor.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(itemData['imageURLs'][0]),
                          ),
                          title: Text(itemData['title']),
                          subtitle: Text(itemData['discountedPrice'] == ""
                              ? 'Price: ${itemData['discountedPrice']} SAR'
                              : 'Price: ${itemData['price']} SAR'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultProfileImage() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Profile')
          .doc(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const CircularProgressIndicator(); // Show loading indicator if data is not yet available
        }
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final defaultImage = userData['userImage'];
        if (defaultImage != null && defaultImage.isNotEmpty) {
          return CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(defaultImage),
            radius: 50,
          );
        } else {
          return const CircleAvatar(
            child: Icon(Icons.person),
            radius: 50,
          ); // Use person icon if defaultImage is not available
        }
      },
    );
  }
}
