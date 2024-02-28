import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchSellerRating(); // Fetch the seller's rating when the page initializes
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
        ratingSnapshot.docs.forEach((doc) {
          totalRating += doc['rating'] as double;
        });
        sellerRating = totalRating / numRatings;
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
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone: $phone',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 20),
            Text(
              '$university',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Rating: ',
                  style: const TextStyle(fontSize: 16),
                ),
                RatingBar.builder(
                  initialRating: sellerRating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
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
              'Number of Ratings: $numRatings',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Collection:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(itemData['imageURLs'][0]),
                      ),
                      title: Text(itemData['title']),
                      subtitle: Text('Price: ${itemData['price']} SAR'),
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
}
