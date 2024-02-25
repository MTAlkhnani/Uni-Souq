import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/my_text_field.dart';
import 'package:unisouq/models/profile.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/utils/size_utils.dart';
import 'dart:io';

class InformationScreen extends StatefulWidget {
  static const String id = 'information_screen';
  final String userId;

  const InformationScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _InformationScreenState createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _universityController;
  late TextEditingController _addressController;
  String? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _universityController = TextEditingController();
    _addressController = TextEditingController();
    _fetchUserData();
  }

  void _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.userId)
          .get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final firstName = userData['FirstName'] ?? '';
        final lastName = userData['LastName'] ?? '';
        final mobileNumber = userData['Phone'] ?? '';

        setState(() {
          _nameController.text = '$firstName $lastName';
          _mobileNumberController.text = mobileNumber;
        });
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            const Text(
              "Edit profile",
              style: TextStyle(fontSize: 20),
            ),
            _buildProfileImage(),
            _buildInputFieldWithName(),
            SizedBox(height: 19.v),
            _buildInputFieldWithMobileNumber(),
            SizedBox(height: 19.v),
            _buildInputFieldWithUniversity(),
            SizedBox(height: 19.v),
            _buildInputFieldWithAddress(),
            SizedBox(height: 50.v),
            _buildCompleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        // Profile picture
        _image != null
            ? ClipRRect(
                borderRadius:
                    BorderRadius.circular(100), // Increase border radius
                child: Image.file(
                  File(_image!),
                  width: 150.v,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              )
            : const CircleAvatar(
                child: Icon(Icons.person),
                radius: 50,
              ),

        // Edit image button
        Positioned(
          bottom: 0,
          right: 0,
          child: MaterialButton(
            elevation: 1,
            onPressed: _showBottomSheet,
            shape: const CircleBorder(),
            color: Colors.white,
            child: const Icon(Icons.edit, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildInputFieldWithName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: const Text(
            "Account Name",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8.v),
        MyTextField(
          hintText: "Full Name",
          keyboardType: TextInputType.text,
          controller: _nameController,
        ),
      ],
    );
  }

  Widget _buildInputFieldWithMobileNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: const Text(
            "Mobile Number",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8.v),
        MyTextField(
          hintText: "9999 999 999",
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
          controller: _mobileNumberController,
        ),
      ],
    );
  }

  Widget _buildInputFieldWithUniversity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: const Text(
            "University",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8.v),
        MyTextField(
          hintText: "University Name",
          keyboardType: TextInputType.text,
          controller: _universityController,
        ),
      ],
    );
  }

  Widget _buildInputFieldWithAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: const Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8.v),
        MyTextField(
          hintText: "Address",
          keyboardType: TextInputType.text,
          controller: _addressController,
        ),
      ],
    );
  }

  Widget _buildCompleteButton() {
    return RoundedButton(
      text: "Complete",
      press: onTapCompleteButton,
      color: Theme.of(context).primaryColor,
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 30.v, bottom: 15.v),
          children: [
            const Text(
              'Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: .02.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(30.v, 15.h),
                  ),
                  onPressed: _pickImageFromGallery,
                  child: Image.asset('assets/images/add_image.png'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(30.v, 15.h),
                  ),
                  onPressed: _takePictureFromCamera,
                  child: Image.asset('assets/images/camera.png'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _image = image.path;
      });
      _updateProfilePicture(File(_image!));
      Navigator.pop(context);
    }
  }

  void _takePictureFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _image = image.path;
      });
      _updateProfilePicture(File(_image!));
      Navigator.pop(context);
    }
  }

  void _updateProfilePicture(File file) {
    try {
      DatabaseService().updateProfilePicture(file, widget.userId);
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }

  void onTapCompleteButton() async {
    try {
      final profile = Profile(
        fName: _nameController.text.split(' ')[0], // Extract first name
        lName: _nameController.text.split(' ')[1], // Extract last name
        phone: int.parse(_mobileNumberController.text),
        userID: widget.userId,
        university: _universityController.text,
        address: _addressController.text,
        userImage: _image,
      );

      await saveProfileData(profile);

      setState(() {
        _nameController.text = '${profile.fName} ${profile.lName}';
      });

      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }

  Future<void> saveProfileData(Profile profile) async {
    try {
      final dbService = DatabaseService();

      // Update the User collection and save profile data
      await dbService.updateUserAndSaveProfile(
        userID: profile.userID,
        fName: profile.fName,
        lName: profile.lName,
        address: profile.address,
        phone: profile.phone,
        university: profile.university,
        userImage: profile.userImage,
      );
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }
}
