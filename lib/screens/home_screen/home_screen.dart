import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:unisouq/components/custom_drawer.dart';
import 'package:unisouq/components/shimmer_loading.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/Search_Screen/searchScreen.dart';
import 'package:unisouq/screens/add_product/add_product.dart';

import 'package:unisouq/screens/my_profile_page/my_profilepage.dart';
import 'package:unisouq/screens/myorder_page/myorder_page.dart';
import 'package:unisouq/screens/notification_page/notification.dart';
import 'package:unisouq/screens/product_screen/product_page.dart';
import 'package:unisouq/screens/request_page/request_page.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:unisouq/service/notification_service.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'customer_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String? selectedCategory;
  int currentIconIndex = 0;
  String? userId;
  late String userID;
  late int unreadNotificationCount = 0; // Add this variable to store the count

  @override
  void initState() {
    super.initState();
    // Default itemsStream to fetch all items initially
    WidgetsBinding.instance?.addObserver(this);
    _getCurrentUserId();
    _createUserActivityCollection();
    itemsStream = FirebaseFirestore.instance.collection('Item').snapshots();
    Future.delayed(const Duration(seconds: 1), () {
      _fetchUnreadNotificationCount();
      NotificationService.saveTokenOnAuthChange();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update user activity status when the user logs in
    _updateUserActivityStatus(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Update user activity status based on app lifecycle state
    switch (state) {
      case AppLifecycleState.resumed:
        _updateUserActivityStatus(true); // User resumed the app
        break;
      case AppLifecycleState.paused:
        _updateUserActivityStatus(false); // User paused the app
        break;
      default:
        break;
    }
  }

  Future<void> _fetchUnreadNotificationCount() async {
    try {
      if (userId != null) {
        int count =
            await NotificationService().getUnreadNotificationCount(userId!);
        setState(() {
          unreadNotificationCount = count;
        });
      } else {
        print('User ID is null.');
      }
    } catch (error) {
      print('Error fetching unread notification count: $error');
    }
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
  void _getCurrentUserId() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
        userID = user.uid;
      });
    }
  }

  void _updateUserActivityStatus(bool isActive) {
    if (userId != null && userId!.isNotEmpty) {
      FirebaseFirestore.instance.collection('user_activity').doc(userId).set({
        'isActive': isActive,
        'lastSeen': Timestamp.now(),
      });
    } else {
      print('User ID is null or empty. Cannot update user activity status.');
    }
  }

  void _createUserActivityCollection() async {
    try {
      // Check if the collection already exists
      bool collectionExists = await FirebaseFirestore.instance
          .collection('user_activity')
          .doc(userId)
          .get()
          .then((docSnapshot) => docSnapshot.exists);

      // If the collection doesn't exist, create it
      if (!collectionExists) {
        await FirebaseFirestore.instance
            .collection('user_activity')
            .doc(userId)
            .set({
          'isActive': false, // Initial value for isActive
          'lastSeen': Timestamp.now(), // Initial value for lastSeen
        });
        print('User activity collection created successfully.');
      } else {
        print('User activity collection already exists.');
      }
    } catch (error) {
      print('Error creating user activity collection: $error');
    }
  }

  @override
  void dispose() {
    // Update user activity status when the user logs out or closes the app
    _updateUserActivityStatus(false);
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
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
    _fetchUnreadNotificationCount();
    final Map<String, String> categoryTranslations = {
      'All Items': S.of(context).popularCategories1,
      'Electronics': S.of(context).popularCategories2,
      'Clothing': S.of(context).popularCategories3,
      'Books': S.of(context).popularCategories4,
      'Furniture': S.of(context).popularCategories5,
      'Home': S.of(context).popularCategories6,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uni-Souq'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // This is the burger icon
              onPressed: () {
                if (isUserSignedIn()) {
                  Scaffold.of(context)
                      .openDrawer(); // This will now work correctly.
                } else {
                  _showSignInRequiredPopup(context);
                }
              },
            );
          },
        ),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  if (!isUserSignedIn()) {
                    // If user is not signed in, show the sign-in required pop-up
                    _showSignInRequiredPopup(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(
                          userId: userID,
                        ),
                      ),
                    );
                  }
                },
              ),
              if (unreadNotificationCount >
                  0) // Check if there are unread notifications
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red, // Color for the notification badge
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadNotificationCount', // actual count of unread notifications
                      style: TextStyle(
                        color: Colors.white, // Text color of the badge
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),

          IconButton(
              icon: const Icon(Icons.shopping_bag),
              onPressed: () {
                if (isUserSignedIn()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RequestPage(), // Navigate to the ContactClientsPage
                    ),
                  );
                } else {
                  // Show sign-in required pop-up if the user is not signed in
                  _showSignInRequiredPopup(context);
                }
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
      drawer: CustomDrawer(),
      body: StreamBuilder(
        stream: itemsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ShimmerLoading();
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
          if (selectedCategory != null &&
              selectedCategory != 'All Items' &&
              selectedCategory != 'جميع العناصر') {
            filteredItems = categoryMap[selectedCategory!] ?? [];
          } else {
            // If selectedCategory is null or 'All Items', show all items
            filteredItems = snapshot.data!.docs;
          }

          // Return a ListView to display categories and their items

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Popular categories section
              Padding(
                padding: EdgeInsets.only(
                    left: isArabic() ? 0 : 10,
                    top: 5,
                    right: isArabic() ? 15 : 0),
                child: Text(
                  S.of(context).Categories,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),

              // Popular categories section
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
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: isSelected
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.7)
                                  : Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(.7),
                              child: Icon(
                                icon,
                                color: isSelected
                                    ? Colors.white
                                    : Theme.of(context)
                                        .shadowColor
                                        .withOpacity(.7),
                              ),
                            ),
                            const SizedBox(
                                height: 3), // Adjust spacing as needed
                            Text(
                              categoryTranslations[category] ?? '',
                              style: TextStyle(
                                color: isSelected
                                    ? Theme.of(context)
                                        .hintColor
                                        .withOpacity(.7)
                                    : Theme.of(context)
                                        .hintColor
                                        .withOpacity(.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Items section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    filteredItems != null && filteredItems.isNotEmpty
                        ? Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.fromLTRB(
                                8,
                                8,
                                8,
                                MediaQuery.of(context).size.height * 0.05,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems![index].data()
                                    as Map<String, dynamic>;

                                double price =
                                    double.parse(item['price'] ?? '0');
                                double discountedPrice = double.parse(
                                    item['discountedPrice'] ?? "0.0");
                                double displayPrice = discountedPrice > 0
                                    ? discountedPrice
                                    : price;

                                return GestureDetector(
                                  onTap: () {
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
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
                                              color:
                                                  Theme.of(context).hoverColor,
                                              child: item['imageURLs'] !=
                                                          null &&
                                                      item['imageURLs']
                                                          .isNotEmpty
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          item['imageURLs'][0],
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              const SpinKitWave(
                                                        color: Colors.white,
                                                        size: 50.0,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: discountedPrice > 0
                                                          ? Theme.of(context)
                                                              .hintColor
                                                              .withOpacity(0.7)
                                                          : null,
                                                    ),
                                                  ),
                                                  if (discountedPrice > 0)
                                                    const SizedBox(width: 8),
                                                  if (discountedPrice > 0)
                                                    Text(
                                                      '${price.toStringAsFixed(0)} SAR',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        decoration:
                                                            TextDecoration
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
                            ),
                          )
                        : Center(
                            child: Text(S.of(context).Noitemsfound),
                          ),
                  ],
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
              child: InkWell(
                onTap: () {
                  setState(() {
                    currentIconIndex = 0;
                  });
                },
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      color: currentIconIndex == 0
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor.withOpacity(0.5),
                      size: 24,
                    ),
                    Text(
                      S.of(context).home,
                      style: TextStyle(
                        fontSize: 12,
                        color: currentIconIndex == 0
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final newIndex = await Navigator.push<int>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                  if (newIndex != null) {
                    setState(() {
                      currentIconIndex = newIndex;
                    });
                  }
                },
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search,
                      color: currentIconIndex == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor.withOpacity(0.5),
                      size: 24,
                    ),
                    Text(
                      S.of(context).search,
                      style: TextStyle(
                        fontSize: 12,
                        color: currentIconIndex == 1
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (isUserSignedIn()) {
                    final newIndex = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyOrderpage(),
                      ),
                    );
                    if (newIndex != null) {
                      setState(() {
                        currentIconIndex = newIndex;
                      });
                    }
                  } else {
                    _showSignInRequiredPopup(context);
                  }
                },
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_shipping,
                      color: currentIconIndex == 2
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor.withOpacity(0.5),
                      size: 24,
                    ),
                    Text(
                      S.of(context).order,
                      style: TextStyle(
                        fontSize: 12,
                        color: currentIconIndex == 2
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (isUserSignedIn()) {
                    final newIndex = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                            userId: FirebaseAuth.instance.currentUser!.uid),
                      ),
                    );
                    if (newIndex != null) {
                      setState(() {
                        currentIconIndex = newIndex;
                      });
                    }
                  } else {
                    _showSignInRequiredPopup(context);
                  }
                },
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      color: currentIconIndex == 3
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor.withOpacity(0.5),
                      size: 24,
                    ),
                    Text(
                      S.of(context).profile,
                      style: TextStyle(
                        fontSize: 12,
                        color: currentIconIndex == 3
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
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
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(S.of(context).SignInRequired),
            content: Text(S.of(context).maslog),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(S.of(context).Cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(S.of(context).SignIn),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  Navigator.pushNamed(context, AppRoutes.signInScreen);
                },
              ),
              CupertinoDialogAction(
                child: Text(S.of(context).SignUp),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  Navigator.pushNamed(context, AppRoutes.signUpScreen);
                },
              ),
            ],
          );
        },
      );
    } else {
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
                  Navigator.pushNamed(context, AppRoutes.signInScreen);
                },
              ),
              TextButton(
                child: Text(S.of(context).SignUp),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  Navigator.pushNamed(context, AppRoutes.signUpScreen);
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool isArabic() {
    return Intl.getCurrentLocale() == 'ar';
  }
}
