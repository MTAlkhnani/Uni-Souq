import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/components/adavtive_dailog.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/add_product/add_product.dart';
import 'package:unisouq/screens/myorder_page/myorder_page.dart';
import 'package:unisouq/screens/product_screen/product_page.dart';
import 'package:unisouq/screens/request_page/request_page.dart';
import 'package:unisouq/screens/sign_in_screen/login_screen.dart';
import 'package:unisouq/screens/sign_up_screen/registeration_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:unisouq/utils/size_utils.dart';

import '../information_Screen/information_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'customer_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;
  int currentIconIndex = 0;
  @override
  void initState() {
    super.initState();
    // Default itemsStream to fetch all items initially
    itemsStream = FirebaseFirestore.instance.collection('Item').snapshots();
  }

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
  String? _selectedUniversity;
  final List<String> _universities = [
    'All Items',
    'King Saud University',
    'King Fahd University of Petroleum and Minerals',
    'King Abdulaziz University',
    'King Khalid University',
    'King Faisal University',
    'Princess Nourah bint Abdulrahman University',
    'Islamic University of Madinah',
    'Imam Abdulrahman Bin Faisal University',
    'Qassim University',
    'Taibah University',
    'Taif University',
    'Umm Al-Qura University',
    'Al-Imam Muhammad Ibn Saud Islamic University',
    'Al-Baha University',
    'Hail University',
    'Jazan University',
    'Majmaah University',
    'Najran University',
    'Northern Borders University',
    'Prince Sattam bin Abdulaziz University',
    'Shaqra University',
    'University of Tabuk',
    'Al Jouf University',
    'Al Yamamah University',
  ];
  // Method to create a ListTile for the Drawer
  ListTile _buildDrawerListTile(
      IconData icon, String title, VoidCallback onTap) {
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
            child: const Text(
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return MyDialog(
                  title: "Sign Out",
                  content: "Are you sure you want to sign out?",
                  cancelText: "Cancel",
                  signOutText: " Sign Out",
                  titleTextStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  contentTextStyle: const TextStyle(fontSize: 16),
                  buttonTextStyle: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 165, 53, 46)),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // Function to handle user sign-out
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.signInScreen, (route) => false);
  }

  void _showUniversitySelectionSheet(BuildContext context) async {
    final selectedUniversity = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _universities.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_universities[index]),
              onTap: () => Navigator.of(context).pop(_universities[index]),
            );
          },
        );
      },
    );

    if (selectedUniversity != null) {
      _selectedUniversity = selectedUniversity; // Do not redeclare

      final userIds = await fetchUserIdsByUniversity(selectedUniversity);
      // print(userIds);
      updateItemsStream(userIds);
    }
    // print(_selectedUniversity);
    // print((_selectedUniversity == null || _selectedUniversity == 'All Items'));
  }

  Stream<QuerySnapshot>? itemsStream;

  void updateItemsStream(List<String> userIds) {
    if (_selectedUniversity == 'All Items') {
      // This ensures that when "All Items" is selected, the stream is set to fetch all items.
      // print("Helooooooo");
      // print(_selectedUniversity);
      // print(
      //     (_selectedUniversity == null || _selectedUniversity == 'All Items'));
      setState(() {
        itemsStream = FirebaseFirestore.instance.collection('Item').snapshots();
      });
    } else if (userIds.isNotEmpty) {
      setState(() {
        itemsStream = FirebaseFirestore.instance
            .collection('Item')
            .where('sellerID', whereIn: userIds)
            .snapshots();
      });
    } else {
      // Handle the case where a university is selected but no user IDs are found
      // print("hellooooo");
      setState(() {
        itemsStream = FirebaseFirestore.instance
            .collection('Item')
            .where('sellerID', isEqualTo: "0")
            .snapshots();
      });
    }
  }

  Future<List<String>> fetchUserIdsByUniversity(String university) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Profile')
        .where('university', isEqualTo: university)
        .get();

    List<String> userIds = [];
    for (var doc in querySnapshot.docs) {
      userIds.add(doc.id); // Assuming the document ID is the user ID
    }
    return userIds;
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
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RequestPage(), // Navigate to the ContactClientsPage
                  ),
                );
              }),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () => _showUniversitySelectionSheet(context),
          ),
          // Remove this IconButton to eliminate the sign-out button from the top right corner
          // IconButton(
          //   icon: const Icon(Icons.exit_to_app),
          //   onPressed: () {
          //     // Sign out logic
          //   },
          //   tooltip: 'Sign Out',
          // ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: StreamBuilder(
        stream: itemsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 170.h, vertical: 10.v),
              child: const SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 4.0,
                ),
              ),
            );
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
                              double.parse(item['discountedPrice'] ?? "0.0");
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
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
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
                                        const SizedBox(height: 4),
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
                                              const SizedBox(width: 8),
                                            if (discountedPrice > 0)
                                              Text(
                                                '${price.toStringAsFixed(0)} SAR',
                                                style: const TextStyle(
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
                    message: 'chat',
                    child: IconButton(
                        icon: const Icon(Icons.local_shipping),
                        color: currentIconIndex == 2
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor.withOpacity(0.5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyOrderpage(), // Navigate to the ContactClientsPage
                            ),
                          );
                        }),
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
                              builder: (context) => InformationScreen(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid),
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
          title: const Text("Sign In Required"),
          content:
              const Text("Please sign in or sign up to access this feature."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Sign In"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first
                Navigator.pushNamed(context,
                    AppRoutes.signInScreen); // Navigate to Sign In Screen
              },
            ),
            TextButton(
              child: const Text("Sign Up"),
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
}
