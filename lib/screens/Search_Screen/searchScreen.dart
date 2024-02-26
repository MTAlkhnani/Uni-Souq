import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unisouq/screens/product_screen/product_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<DocumentSnapshot> _searchResults = [];

  void searchItems(String query) async {
    var collection = FirebaseFirestore.instance.collection('Item');
    var snapshots = await collection
        .get(); // Note: Consider scalability and cost implications

    String searchLowercase = query.toLowerCase();

    var filteredResults = snapshots.docs.where((doc) {
      final title = doc.get('title') as String;
      final category = doc.get('category') as String;
      final condition = doc.get('condition') as String;
      final description = doc.get('description') as String;

      // Check if any of the fields contain the search query
      return title.toLowerCase().contains(searchLowercase) ||
          category.toLowerCase().contains(searchLowercase) ||
          condition.toLowerCase().contains(searchLowercase) ||
          description.toLowerCase().contains(searchLowercase);
    }).toList();

    setState(() {
      _searchResults = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search', style: theme.textTheme.headline6),
        backgroundColor: theme.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                onSearchChanged: (query) => searchItems(query),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Item').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    // Items section
                    _searchResults != null && _searchResults.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // Important
                            padding: EdgeInsets.fromLTRB(
                              8,
                              8,
                              8,
                              MediaQuery.of(context).size.height *
                                  0.05, // Adjust the bottom padding using MediaQuery
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _searchResults.length,
                            // Inside the GridView.builder itemBuilder method, update the UI of each item card
                            itemBuilder: (context, index) {
                              final item = _searchResults[index].data()
                                  as Map<String, dynamic>;

                              // Calculate the discounted price if available
                              double price = double.parse(item['price'] ?? '0');
                              double discountedPrice =
                                  double.parse(item['discountedPrice'] ?? "0");
                              double displayPrice =
                                  discountedPrice > 0 ? discountedPrice : price;

                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the product detail screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(
                                        productId: _searchResults[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 14,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            color: Theme.of(context).hoverColor,
                                            child: item['imageURLs'] != null &&
                                                    item['imageURLs'].isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: item['imageURLs'][
                                                        0], // Use the first image URL
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'] ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  '${displayPrice.toStringAsFixed(0)} SAR',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: discountedPrice > 0
                                                        ? Theme.of(context)
                                                            .hintColor
                                                            .withOpacity(
                                                                0.7) // If discounted price is available, display it in red
                                                        : null, // Otherwise, use the default text color
                                                  ),
                                                ),
                                                if (discountedPrice >
                                                    0) // Display the original price if discounted price is available
                                                  SizedBox(width: 8),
                                                if (discountedPrice > 0)
                                                  Text(
                                                    '${price.toStringAsFixed(0)} SAR',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text('No items found.'),
                          ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  const SearchBar({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: onSearchChanged, // Added
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
          border: InputBorder.none,
          hintStyle: TextStyle(color: theme.hintColor),
        ),
        style: TextStyle(color: theme.textTheme.bodyText1?.color),
      ),
    );
  }
}
