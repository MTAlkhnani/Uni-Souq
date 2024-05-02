import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unisouq/components/Rounded_Button.dart';
import 'package:unisouq/components/my_text_field.dart';
import 'package:unisouq/generated/l10n.dart';
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
  late TextEditingController _imageController;
  String? _image;
  bool _isLoading = false;

  String? _selectedUniversity;
  final List<String> _universities = [
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _universityController = TextEditingController();
    _addressController = TextEditingController();
    _imageController = TextEditingController();
    _fetchUserData();
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController objects
    _nameController.dispose();
    _mobileNumberController.dispose();
    _universityController.dispose();
    _addressController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Profile')
          .doc(widget.userId)
          .get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final firstName = userData['fName'] ?? '';
        final lastName = userData['lName'] ?? '';
        final mobileNumber = userData['phone'] ?? '';
        final university = userData['university'] ?? '';
        final address = userData['address'] ?? '';
        final _image = userData['userImage'];
        print('${university.toString()}');
        setState(() {
          _nameController.text =
              '${firstName.toString()} ${lastName.toString()}';
          _mobileNumberController.text = mobileNumber.toString();
          _selectedUniversity = university.toString();
          _addressController.text = address.toString();
          _imageController.text = _image.toString();
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
              height: 35.h,
            ),
            Text(
              S.of(context).Editprofile,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 45.h,
            ),
            _buildProfileImage(),
            _buildInputFieldWithName(),
            SizedBox(height: 19.v),
            _buildInputFieldWithMobileNumber(),
            SizedBox(height: 19.v),
            _buildUniversityDropdown(),
            SizedBox(height: 19.v),
            _buildInputFieldWithAddress(),
            SizedBox(height: 30.v),
            _buildCancelButton(),
            _buildCompleteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return RoundedButton(
      text: S.of(context).Cancel,
      press: () {
        if (ModalRoute.of(context)!.settings.name == AppRoutes.signUpScreen) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
        }
      },
      color: Colors.redAccent,
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100), // Increase border radius
          child: _determineImageWidget(),
        ),
        // Edit image button remains the same
        Positioned(
          bottom: 0,
          right: 0,
          child: MaterialButton(
            elevation: 3,
            onPressed: _showBottomSheet,
            shape: const CircleBorder(),
            color: Colors.white,
            child: const Icon(Icons.edit, color: Colors.blue),
          ),
        ),
      ],
    );
  }

// Helper method to determine which widget to use for displaying the image
  Widget _determineImageWidget() {
    if (_image != null && _image!.isNotEmpty && !_image!.startsWith('http')) {
      return Image.file(File(_image!),
          width: 150, height: 150, fit: BoxFit.cover);
    } else if (_imageController.text.isNotEmpty &&
        Uri.tryParse(_imageController.text)?.isAbsolute == true) {
      return Image.network(_imageController.text,
          width: 150, height: 150, fit: BoxFit.cover);
    } else {
      return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Profile')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const CircularProgressIndicator(); // Show loading indicator if data is not yet available
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final defaultImage = userData['defaultImage'];
          if (defaultImage != null && defaultImage.isNotEmpty) {
            return Image.network(defaultImage,
                width: 150, height: 150, fit: BoxFit.cover);
          } else {
            return const CircleAvatar(
                child: Icon(Icons.person),
                radius:
                    50); // Use default placeholder if defaultImage is not available
          }
        },
      );
    }
  }

  Widget _buildInputFieldWithName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: Text(
            S.of(context).AccountName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8.v),
        MyTextField(
          hintText: S.of(context).FullName,
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
          child: Text(
            S.of(context).MobileNumber,
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

  Widget _buildUniversityDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).University,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8.v),
          DropdownButtonFormField<String>(
            // Set the dropdown's value to _selectedUniversity if it's a valid university, otherwise null.
            value: _universities.contains(_selectedUniversity)
                ? _selectedUniversity
                : null,
            hint: Text(S.of(context).SelectUniversity),
            isExpanded: true,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            onChanged: (String? newValue) {
              setState(() {
                _selectedUniversity = newValue;
                _universityController.text = newValue ?? "";
              });
            },
            items: _universities.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            dropdownColor: Theme.of(context).secondaryHeaderColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInputFieldWithAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.h),
          child: Text(
            S.of(context).Address,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(height: 8.v),
        MyTextField(
          hintText: S.of(context).Address,
          keyboardType: TextInputType.text,
          controller: _addressController,
        ),
      ],
    );
  }

  Widget _buildCompleteButton() {
    return RoundedButton(
      text: S.of(context).Complete,
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
            Text(
              S.of(context).PickProfilePicturec,
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
      imageQuality: 5,
    );
    if (image != null) {
      setState(() {
        _image = image.path;
        // print(_image);
      });
      _updateProfilePicture(File(_image!));
      Navigator.pop(context);
    }
  }

  void _takePictureFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 5,
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
    print('Local image path: $_image');
    print('Network image URL: ${_imageController.text}');
    try {
      if (_imageController.text.isNotEmpty) {
        _image = _imageController.text;
      }
      // print(_imageController.text);
      // print(_image);

      final profile = Profile(
        fName: _nameController.text.split(' ')[0], // Extract first name
        lName: _nameController.text.split(' ')[1], // Extract last name
        phone: _mobileNumberController.text,
        userID: widget.userId,
        university: _selectedUniversity,
        address: _addressController.text,
        userImage: _image ?? "",
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
        userImage: profile.userImage ?? "",
      );
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }
}
