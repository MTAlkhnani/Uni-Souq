import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unisouq/app.dart';
import 'package:unisouq/components/adavtive_dailog.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/language_page/language_Screen.dart';
import 'package:unisouq/screens/payment_page/cardpaymentview.dart';
import 'package:unisouq/utils/size_utils.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late User? _user;
  late Map<String, dynamic> _profileData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the drawer is initialized
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });

      final snapshot = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(user.uid)
          .get();

      setState(() {
        _profileData = snapshot.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).splashColor,
                  Theme.of(context).primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _user != null &&
                    _profileData.containsKey('userImage') &&
                    _profileData['userImage'] != null &&
                    _profileData['userImage'] != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: _profileData['userImage'],
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 70,
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 22.h),
                        child: Text(
                          '${_profileData['fName'] ?? ''} ${_profileData['lName'] ?? ''}',
                          style: GoogleFonts.getFont(
                            'Roboto', // Example: Use Roboto font from Google Fonts
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 20.h, top: 70.v),
                    child: Text(
                      '${_profileData['fName'] ?? ''} ${_profileData['lName'] ?? ''}',
                      style: GoogleFonts.getFont(
                        'Roboto', // Example: Use Roboto font from Google Fonts
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

            // Show nothing if user data or image URL is not available
          ),
          _buildDrawerListTile(Icons.lock, S.of(context).ResetPassword, () {
            // Implement navigation to reset password
          }),
          _buildDrawerListTile(Icons.shopping_bag, S.of(context).MyCollectiond,
              () {
            // Implement navigation to language settings
            if (isUserSignedIn()) {
              Navigator.pushNamed(context, AppRoutes.mycollrctionpage);
            } else {
              // Show sign-in required pop-up if the user is not signed in
              _showSignInRequiredPopup(context);
            }
          }),
          _buildDrawerListTile(Icons.language, S.of(context).Language, () {
            // Implement navigation to langu  age settings

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguagePage()),
            );
          }),
          _buildDrawerListTile(Icons.help, S.of(context).HelpCenter, () {
            // Implement navigation to help center
          }),
          _buildDrawerListTile(Icons.payment, S.of(context).Payment, () async {
            // Check if user is signed in
            if (isUserSignedIn()) {
              // Get the current user ID
              final userId = FirebaseAuth.instance.currentUser!.uid;

              // Navigate to CardPaymentView with the user ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardPaymentView(
                    userId: userId,
                  ),
                ),
              );
            } else {
              // Show sign-in required pop-up if the user is not signed in
              _showSignInRequiredPopup(context);
            }
          }),
          _buildDrawerListTile(Icons.security, S.of(context).Security, () {
            // Implement navigation to security settings
          }),
          _buildDrawerListTile(Icons.exit_to_app, S.of(context).SignOut, () {
            _showSignOutDialog(context);
          }),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(S.of(context).SignOut),
            content: Text(S.of(context).SignOutb),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(S.of(context).Cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog first
                  // Perform sign out action here
                },
                isDestructiveAction: true,
                child: Text(S.of(context).SignOut),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyDialog(
            title: S.of(context).SignOut,
            content: S.of(context).SignOutb,
            cancelText: S.of(context).Cancel,
            signOutText: S.of(context).SignOut,
            titleTextStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            contentTextStyle: const TextStyle(fontSize: 16),
            buttonTextStyle: const TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 165, 53, 46)),
          );
        },
      );
    }
  }

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
