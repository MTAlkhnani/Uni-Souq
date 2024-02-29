import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unisouq/screens/product_screen/product_page.dart';
import 'package:unisouq/utils/size_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<DocumentSnapshot> _searchResults = [];
  List<String> _suggestedKeywords = [
    'book',
    'Sony',
    'Watches',
    'Accessories',
    'frige',
    'Home Decor',
  ];

  late FocusNode _searchFocusNode;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void searchItems(String query) async {
    var collection = FirebaseFirestore.instance.collection('Item');
    var snapshots = await collection.get();

    String searchLowercase = query.toLowerCase();

    var filteredResults = snapshots.docs.where((doc) {
      final title = doc.get('title') as String;
      final category = doc.get('category') as String;
      final condition = doc.get('condition') as String;
      final description = doc.get('description') as String;

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
                onSearchChanged: (query) {
                  setState(() {
                    _searchController.text = query;
                  });
                  searchItems(query);
                },
                focusNode: _searchFocusNode,
                controller: _searchController,
              ),
            ),
            if ((!_searchFocusNode.hasFocus &&
                    _searchController.text.isEmpty &&
                    _searchResults.isEmpty) ||
                (_searchFocusNode.hasFocus &&
                    _searchController.text.isEmpty &&
                    _searchResults.isEmpty))
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding:
                    EdgeInsets.symmetric(vertical: 120.v, horizontal: 10.h),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 18,
                  childAspectRatio:
                      1.75, // Adjust this value to make the containers smaller
                ),
                itemCount: _suggestedKeywords.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.text = _suggestedKeywords[index];
                      });
                      searchItems(_suggestedKeywords[index]);
                    },
                    child: Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: Text(
                          _suggestedKeywords[index],
                          style: TextStyle(
                            fontSize:
                                14, // Adjust the font size to make the keywords smaller
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            if (!_searchFocusNode.hasFocus &&
                    _searchController.text.isNotEmpty &&
                    _searchResults.isEmpty ||
                _searchFocusNode.hasFocus &&
                    _searchController.text.isNotEmpty &&
                    _searchResults.isEmpty)
              Center(child: Text('No items found.')),
            if ((_searchFocusNode.hasFocus &&
                    _searchController.text.isNotEmpty &&
                    _searchResults.isNotEmpty) ||
                (!_searchFocusNode.hasFocus &&
                    _searchController.text.isNotEmpty &&
                    _searchResults.isNotEmpty))
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Item').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return (_searchFocusNode.hasFocus &&
                              _searchResults.isNotEmpty &&
                              _searchController.text.isNotEmpty) ||
                          (!_searchFocusNode.hasFocus &&
                              _searchResults.isNotEmpty &&
                              _searchController.text.isNotEmpty)
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final item = _searchResults[index].data()
                                as Map<String, dynamic>;

                            double price = double.parse(item['price'] ?? '0');
                            double discountedPrice =
                                double.parse(item['discountedPrice'] ?? "0");
                            double displayPrice =
                                discountedPrice > 0 ? discountedPrice : price;

                            return GestureDetector(
                              onTap: () {
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 14,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          color: Theme.of(context).hoverColor,
                                          child: item['imageURLs'] != null &&
                                                  item['imageURLs'].isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: item['imageURLs']
                                                      [0],
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
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
                                                          .withOpacity(0.7)
                                                      : null,
                                                ),
                                              ),
                                              if (discountedPrice > 0)
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
                      : const SizedBox(); // Empty SizedBox when no items found and search bar not focused
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
  final FocusNode focusNode;
  final TextEditingController controller;

  const SearchBar({
    Key? key,
    required this.onSearchChanged,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

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
        onChanged: onSearchChanged,
        focusNode: focusNode,
        controller: controller,
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
