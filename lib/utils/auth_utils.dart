import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getUserId() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // Get the current user from Firebase Authentication
  User? user = _auth.currentUser;

  if (user != null) {
    // If the user is signed in, return the user ID
    return user.uid;
  } else {
    // If no user is signed in, return null
    return null;
  }
}
