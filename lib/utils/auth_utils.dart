import 'package:cloud_firestore/cloud_firestore.dart';
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

Future<String?> retrieveFullName(String userId) async {
  try {
    // Get the document snapshot corresponding to the user's UID
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('User').doc(userId).get();

    // Check if the document exists
    if (userDoc.exists) {
      // Extract the first name and last name from the document
      String? firstName = userDoc['FirstName'] ?? '';
      String? lastName = userDoc['LastName'] ?? '';

      // Combine first name and last name
      if (firstName != null && lastName != null) {
        String fullName = '$firstName $lastName';
        return fullName;
      } else {
        // Handle case where either first name or last name is null
        return 'Name not available';
      }
    } else {
      // Handle case where document doesn't exist
      return 'User not found';
    }
  } catch (e) {
    // Handle error
    print('Error retrieving user data: $e');
    return 'Error retrieving user data';
  }
}
