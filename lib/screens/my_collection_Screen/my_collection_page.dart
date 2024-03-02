import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:unisouq/components/custom_snackbar.dart';
import 'package:unisouq/screens/edit_product_screen/edit_product.dart';

import 'package:unisouq/screens/massaging_screan/contact_ciients_page.dart';
import 'package:unisouq/screens/my_profile_page/my_profilepage.dart'; // Import the ContactClientsPage

class MyCollectionPage extends StatefulWidget {
  static const String id = 'mycollection_screen';
  @override
  _MyCollectionPageState createState() => _MyCollectionPageState();
}

class _MyCollectionPageState extends State<MyCollectionPage> {
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  void getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    currentUserId = user?.uid ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Network'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'My Collection'),
              Tab(text: 'My Clients'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyCollectionTab(),
            // Remove ContactClientsPage from here
            ContactClientsPage(), // Placeholder for the second tab content
          ],
        ),
      ),
    );
  }

  Widget _buildMyCollectionTab() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Item')
          .where('sellerID', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No items found in your collection.'),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final item = snapshot.data!.docs[index].data();
              if (item != null && item is Map<String, dynamic>) {
                return GestureDetector(
                  onTap: () {
                    print('Item ID: ${item['itemID']}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(
                          productData: item,
                        ),
                      ),
                    ).then((value) {
                      if (value == true) {
                        setState(() {});
                      }
                    });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              color: Theme.of(context).hoverColor,
                              child: item['imageURLs'] != null &&
                                      item['imageURLs'].isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: item['imageURLs']
                                          [0], // Use the first image URL
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Row(
                            children: [
                              Flexible(
                                child: ListTile(
                                  title: Text(
                                    item['title'] ?? 'Item not available',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  subtitle: item['price'] != null
                                      ? Text(
                                          'Price: ${item['price']} SAR',
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Card(
                  child: ListTile(
                    title: Text('Item not available'),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
