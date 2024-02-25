import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Profile {
  final String fName;
  final String lName;
  final String? address;
  final int phone;
  final String? university;
  final String userID;
  final String? userImage;

  Profile({
    required this.fName,
    required this.lName,
    this.address,
    required this.phone,
    this.university,
    required this.userID,
    this.userImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'fName': fName,
      'lName': lName,
      'address': address,
      'phone': phone,
      'university': university,
      'userID': userID,
      'userImage': userImage
    };
  }
}

class DatabaseService {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('User');
  final CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('Profile');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> updateUserAndSaveProfile({
    required String userID,
    required String fName,
    required String lName,
    String? address,
    required int phone,
    String? university,
    String? userImage,
  }) async {
    try {
      // Update the User collection
      await _userCollection.doc(userID).update({
        'FirstName': fName,
        'LastName': lName,
        'Phone': phone,
      });

      // Save data in the Profile collection
      await _profileCollection.doc(userID).set({
        'fName': fName,
        'lName': lName,
        'address': address,
        'phone': phone,
        'university': university,
        'userID': userID,
        'userImage': userImage,
      });
    } catch (e) {
      print('Error updating user and saving profile: $e');
      throw e;
    }
  }

  Future<void> updateProfilePicture(File file, String userID) async {
    try {
      // Get the file extension
      final ext = file.path.split('.').last;

      // Storage file reference with path
      final ref = _storage.ref().child('profile_pictures/$userID.$ext');

      // Upload the image file
      await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));

      // Get the download URL for the uploaded image
      final imageUrl = await ref.getDownloadURL();

      // Check if the document exists in the 'Profile' collection
      final docSnapshot = await _profileCollection.doc(userID).get();
      if (docSnapshot.exists) {
        // Update the 'userImage' field in the 'Profile' collection
        await _profileCollection.doc(userID).update({'userImage': imageUrl});
      } else {
        print(
            'Document with userID $userID does not exist in the Profile collection.');
      }

      print('Profile picture updated successfully');
    } catch (e) {
      print('Error updating profile picture: $e');
      throw e;
    }
  }
}
