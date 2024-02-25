import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unisouq/screens/information_screen/information_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile_page';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    final User? user = _auth.currentUser;
    return user?.uid; // This will be null if no user is logged in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Settings'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Implement logout functionality
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/profile_pic.jpg'),
              ),
              title: Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('johndoe@example.com'),
            ),
            const Divider(),
            buildListTile(
              context,
              icon: Icons.person,
              title: 'Personal Information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        InformationScreen(userId: getCurrentUserId()!),
                  ),
                );
              },
            ),
            buildListTile(
              context,
              icon: Icons.lock,
              title: 'Reset Password',
              onTap: () {
                // Navigate to reset password screen
              },
            ),
            buildListTile(
              context,
              icon: Icons.language,
              title: 'Language',
              onTap: () {
                // Navigate to language settings screen
              },
            ),
            buildListTile(
              context,
              icon: Icons.help,
              title: 'Help Center',
              onTap: () {
                // Navigate to help center screen
              },
            ),
            buildListTile(
              context,
              icon: Icons.security,
              title: 'Security',
              onTap: () {
                // Navigate to security settings screen
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: onTap,
    );
  }
}
