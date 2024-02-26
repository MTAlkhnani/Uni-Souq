import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/components/adavtive_dailog.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/add_product/add_product.dart';
import 'package:unisouq/screens/notification_page/notification_page.dart';
import 'package:unisouq/screens/product_screen/product_page.dart';
import 'package:unisouq/screens/profile_page/profile_screen.dart';
import 'package:unisouq/screens/sign_in_screen/login_screen.dart';
import 'package:unisouq/screens/sign_up_screen/registeration_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../information_Screen/information_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'customer_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;
  int currentIconIndex = 0;

  // Define a list of icons for popular categories
  final List<IconData> popularCategoryIcons = [
    Icons.all_inclusive, // All Items
    Icons.phone, // Electronics
    Icons.shopping_bag, // Clothing
    Icons.menu_book, // Books
    Icons.weekend, // Furniture
    Icons.home,
    // Add more icons for additional categories as needed
  ];

  // Define a list of category names
  final List<String> popularCategories = [
    'All Items',
    'Electronics',
    'Clothing',
    'Books',
    'Furniture',
    'Home'
    // Add more categories as needed
  ];


  // Method to create a ListTile for the Drawer
  ListTile _buildDrawerListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }

  // Method to build the Drawer
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          ),
          _buildDrawerListTile(Icons.lock, 'Reset Password', () {
            // Implement navigation to reset password
          }),
          _buildDrawerListTile(Icons.language, 'Language', () {
            // Implement navigation to language settings
          }),
          _buildDrawerListTile(Icons.help, 'Help Center', () {
            // Implement navigation to help center
          }),
          _buildDrawerListTile(Icons.security, 'Security', () {
            // Implement navigation to security settings
          }),
          _buildDrawerListTile(Icons.exit_to_app, 'Sign Out', () {
            // Call the _signOut method here
            _signOut(context);
          }),
        ],
      ),
    );
  }

  // Function to handle user sign-out
  void _signOut(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Just close the dialog
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                // If confirmed, sign out and navigate to sign-in screen
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // Close the dialog first
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.signInScreen, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uni-Souq'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // This is the burger icon
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // This will now work correctly.
              },
            );
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.location_on), onPressed: () {}),
          IconButton(icon: const Icon(Icons.category), onPressed: () {}),

        ],
      ),
      drawer: _buildDrawer(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Item').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Group items by category
          Map<String, List<DocumentSnapshot>> categoryMap = {};
          snapshot.data!.docs.forEach((doc) {
            final item = doc.data() as Map<String, dynamic>;
            String category = item['category'] ?? 'Other';

            // Ensure category is not null or empty before adding to the map
            if (category.isNotEmpty) {
              categoryMap.putIfAbsent(category, () => []);
              categoryMap[category]!.add(doc);
            }
          });

          // Filter items based on selected category
          List<DocumentSnapshot>? filteredItems;
          if (selectedCategory != null && selectedCategory != 'All Items') {
            filteredItems = categoryMap[selectedCategory!] ?? [];
          } else {
            // If selectedCategory is null or 'All Items', show all items
            filteredItems = snapshot.data!.docs;
          }

          // Return a ListView to display categories and their items
          return Column(
            children: [
              // Popular categories section
              const Padding(
                padding: EdgeInsets.only(left: 0, top: 5),
                child: Text(
                  'Popular Categories',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: popularCategories.map((category) {
                    // Get the index of the current category
                    int index = popularCategories.indexOf(category);
                    // Get the corresponding icon
                    IconData icon = popularCategoryIcons[index];
                    // Check if the category is selected
                    bool isSelected = selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Chip(
                          avatar: Icon(icon,
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context)
                                      .hintColor
                                      .withOpacity(.7)),
                          label: Text(
                            category,
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .hintColor
                                        .withOpacity(.7)),
                          ),
                          backgroundColor: isSelected
                              ? Theme.of(context).primaryColor.withOpacity(.7)
                              : Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Items section
              Expanded(
                child: filteredItems != null && filteredItems.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
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
                        itemCount: filteredItems.length,
                        // Inside the GridView.builder itemBuilder method, update the UI of each item card
                        itemBuilder: (context, index) {
                          final item = filteredItems![index].data()
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
                                    productId: filteredItems![index].id,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                                                imageUrl: item['imageURLs'][
                                                    0], // Use the first image URL
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
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.home),
                    color: currentIconIndex == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor.withOpacity(0.5),
                    onPressed: () {
                      setState(() {
                        currentIconIndex = 0;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: currentIconIndex == 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor.withOpacity(0.5),
                    onPressed: () {
                      setState(() {
                        currentIconIndex = 1;
                      });
                      // Add the navigation call here
                      Navigator.pushNamed(context, AppRoutes.searchScreen);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: Column(
                children: [
                  Tooltip(
                    message: 'Notifications',
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      color: currentIconIndex == 2
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor.withOpacity(0.5),
                      onPressed: () async {
                        if (isUserSignedIn()) {
                          // Proceed with the original logic if the user is signed in
                          final newIndex = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationPage(
                                senderName: '',
                                message: '',
                              ),
                            ),
                          );
                          if (newIndex != null) {
                            setState(() {
                              currentIconIndex = newIndex;
                            });
                          }
                        } else {
                          // Show sign-in required pop-up if the user is not signed in
                          _showSignInRequiredPopup(context);
                        }
                      },

                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Tooltip(
                    message: 'Profile',
                    child: IconButton(
                      icon: const Icon(Icons.person),
                      color: currentIconIndex == 2
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor.withOpacity(0.5),
                      onPressed: () async {
                        if (isUserSignedIn()) {
                          // Proceed with the original logic if the user is signed in
                          final newIndex = await Navigator.push<int>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InformationScreen(userId: FirebaseAuth.instance.currentUser!.uid),
                            ),
                          );
                          if (newIndex != null) {
                            setState(() {
                              currentIconIndex = newIndex;
                            });
                          }
                        } else {
                          // Show sign-in required pop-up if the user is not signed in
                          _showSignInRequiredPopup(context);
                        }
                      },

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (!isUserSignedIn()) {
            // If user is not signed in, show the sign-in required pop-up
            _showSignInRequiredPopup(context);
          } else {
            // If user is signed in, proceed to the AddProductScreen
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AddProductScreen()),
            );
          }
        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
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


}
