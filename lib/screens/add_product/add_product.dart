import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unisouq/components/custom_snackbar.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/utils/size_utils.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController(); // Added for discounted price
  late List<String> _categories;
  late List<String> _conditions;
  String? _selectedCategory;
  String? _selectedCondition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categories = initializeCategories(context);
    _conditions = initializeConditions(context);
  }

  List<String> initializeCategories(BuildContext context) {
    return [
      S.of(context).popularCategories2,
      S.of(context).popularCategories3,
      S.of(context).popularCategories4,
      S.of(context).popularCategories6,
      S.of(context).popularCategories5,
    ];
  }

  List<String> initializeConditions(BuildContext context) {
    return [
      S.of(context).c1,
      S.of(context).c2,
      S.of(context).c3,
      S.of(context).c4,
    ];
  }

  List<File> _images = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _discountPriceController
        .dispose(); // Dispose the discounted price controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).AddProduct),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _showBottomSheet,
                    child: Text(S.of(context).AddPictures),
                  ),
                  _images.isNotEmpty
                      ? SizedBox(
                          height: 200,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              File image = _images[index];
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.file(image, fit: BoxFit.cover),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Container(),
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(labelText: S.of(context).ProductName),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).Pleaseentername;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: Text(S.of(context).SelectCategory),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) => value == null
                        ? S.of(context).Pleaseselectacategory
                        : null,
                    dropdownColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCondition,
                    hint: Text(S.of(context).SelectCondition),
                    onChanged: (value) {
                      setState(() {
                        _selectedCondition = value;
                      });
                    },
                    items: _conditions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    validator: (value) => value == null
                        ? S.of(context).Pleaseselectacondition
                        : null,
                    dropdownColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration:
                        InputDecoration(labelText: S.of(context).Description),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).Pleaseenteradescription;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: S.of(context).Price),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty && value == 0) {
                        return S.of(context).Pleaseprice;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _discountPriceController,
                    decoration: InputDecoration(
                        labelText: S
                            .of(context)
                            .DiscountedPrice), // Added discounted price field
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitProduct,
                    child: Text(S.of(context).SubmitProduct),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage(
      imageQuality: 5,
    );

    if (pickedImages != null && pickedImages.isNotEmpty) {
      // Compress images and wait for all to complete
      final List<File> compressedFiles =
          await Future.wait(pickedImages.map((xFile) async {
        // Compress each image
        final XFile? compressedXFile = await compressFile(xFile);
        // Convert XFile to File
        return File(compressedXFile!
            .path); // Assuming compressFile always returns a non-null XFile
      }));

      setState(() {
        _images = _images + compressedFiles;
      });
    }
    // Navigator.pop(context);
  }

  Future<void> _takePictureFromCamera() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 5,
    );
    if (image != null) {
      final File compressedImage = File((await compressFile(image))!.path);
      setState(() {
        _images.add(compressedImage);
      });
    }
    // Navigator.pop(context);
  }

  Future<List<String?>> _uploadImages(List<File> images) async {
    List<String?> downloadUrls = [];

    for (File image in images) {
      // final img = await compressFile(image);
      String fileName =
          'products/${DateTime.now().millisecondsSinceEpoch}_${images.indexOf(image)}.png';
      try {
        final ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(image);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print(e);
        downloadUrls.add(
            'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png');
      }
    }

    return downloadUrls;
  }

  Future<XFile?> compressFile(XFile file) async {
    final imagePath = file.path;
    // eg:- "Volume/VM/abcd_out.jpeg"
    if (imagePath.contains('heic') || imagePath.contains('heif')) {
      // print("trwsindgsonodsn");
      final tmpDir = (await getTemporaryDirectory()).path;
      final target = '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpeg';
      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        target,
        format: CompressFormat.jpeg,
        quality: 5,
      );
      return result;
    }
    // print("hellooooo");
    final lastIndex = imagePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = imagePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${imagePath.substring(lastIndex)}";
    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 5,
    );

    return result;
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? S.of(context).NotSignedIn;
    return uid;
  }

  Future<String> getCurrentUserEmailByUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in
      final String uid = user.uid;
      try {
        // Query the "User" collection for documents where "UserId" matches the current user's UID
        final querySnapshot = await FirebaseFirestore.instance
            .collection('User')
            .where('UserId', isEqualTo: uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming the first document found is the correct one
          final documentSnapshot = querySnapshot.docs.first;
          if (documentSnapshot.exists &&
              documentSnapshot.data().containsKey('Email')) {
            return documentSnapshot.get('Email'); // Return the user's email
          } else {
            return 'Email not found'; // Email field does not exist in the document
          }
        } else {
          return 'No user document matches the current UserID';
        }
      } catch (e) {
        // Handle errors (e.g., insufficient permissions, network issues)
        return 'Error retrieving user email: $e';
      }
    } else {
      // User is not signed in
      return 'User not signed in';
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      setState(() => _isLoading = true);
      _showLoadingDialog();
      try {
        final List<String?> imageUrls = await _uploadImages(_images);
        final List<String> validImageUrls =
            imageUrls.where((url) => url != null).map((url) => url!).toList();

        // Map the selected category to its English translation
        final String translatedCategory =
            _translateToEnglish(_selectedCategory);
        final String translatedcondtion =
            _translateToEnglishcondtion(_selectedCondition);
        String userEmail = await getCurrentUserEmailByUserId();

        DocumentReference docRef =
            FirebaseFirestore.instance.collection('Item').doc();
        String itemId = docRef.id;

        await FirebaseFirestore.instance.collection('Item').add({
          'title': _nameController.text,
          'price': _priceController.text,
          'discountedPrice':
              _discountPriceController.text, // Added discounted price field
          'description': _descriptionController.text,
          'sellerID': getCurrentUserUid(),
          'category': translatedCategory, // Use the translated category
          'condition': translatedcondtion,
          'user': userEmail,
          'itemID': itemId,
          'imageURLs': validImageUrls,
          'status': 'available', // Add item status
          'timestamp': Timestamp.now(),
        });

        Navigator.of(context).pop();
        showSuccessMessage(context, S.of(context).Productaddedsuccessfully);
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();
        showErrorMessage(context, "Some error happened: ${e.toString()}");
      }
      setState(() => _isLoading = false);
    }
  }

  String _translateToEnglish(String? category) {
    switch (category) {
      case 'الإلكترونيات':
        return 'Electronics'; // Translate the Arabic category to English
      case 'الملابس':
        return 'Clothing';
      case 'الكتب':
        return 'Books';
      case 'الأثاث':
        return 'Furniture';
      case 'المنزل':
        return 'Home';
      // Add more cases for other categories
      default:
        return category ??
            ''; // Return the original category if translation not found
    }
  }

  String _translateToEnglishcondtion(String? condtion) {
    switch (condtion) {
      case 'جديد':
        return 'New'; // Translate the Arabic category to English
      case 'مستعمل - كالجديد':
        return 'Used - Like New';
      case 'مستعمل - جيد':
        return 'Used - Good';
      case 'مستعمل - قابل للاستخدام':
        return 'Used - Acceptable';
      // Add more cases for other categories
      default:
        return condtion ??
            ''; // Return the original category if translation not found
    }
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
              S.of(context).PickProfilePicture,
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
                  onPressed: _pickImages,
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
}
