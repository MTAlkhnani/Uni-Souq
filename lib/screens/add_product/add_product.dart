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
  String? _selectedCategory;
  String? _selectedCondition;
  final List<String> _categories = [
    'Electronics',
    'Books',
    'Clothing',
    'Home',
    'Toys'
  ];
  final List<String> _conditions = [
    'New',
    'Used - Like New',
    'Used - Good',
    'Used - Acceptable'
  ];
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
        title: Text('Add Product'),
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
                    child: Text('Add Pictures'),
                  ),
                  _images.isNotEmpty
                      ? SizedBox(
                          height: 200,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                    icon: Icon(Icons.close, color: Colors.red),
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
                    decoration: InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: Text('Select Category'),
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
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                    dropdownColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCondition,
                    hint: Text('Select Condition'),
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
                    validator: (value) =>
                        value == null ? 'Please select a condition' : null,
                    dropdownColor: Theme.of(context).secondaryHeaderColor,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty && value == 0) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _discountPriceController,
                    decoration: InputDecoration(
                        labelText:
                            'Discounted Price'), // Added discounted price field
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitProduct,
                    child: Text('Submit Product'),
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
    final ImagePicker _picker = ImagePicker();
    final List<XFile> pickedImages = await _picker.pickMultiImage(
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
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String getCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? "Not Signed In";
    return uid;
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      setState(() => _isLoading = true);
      _showLoadingDialog();
      try {
        final List<String?> imageUrls = await _uploadImages(_images);
        final List<String> validImageUrls =
            imageUrls.where((url) => url != null).map((url) => url!).toList();
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
          'category': _selectedCategory,
          'condition': _selectedCondition,
          'user': "N/A",
          'itemID': itemId,
          'imageURLs': validImageUrls,
          'status': 'available', // Add item status
        });

        Navigator.of(context).pop();
        showSuccessMessage(context, "Product added successfully");
        Navigator.of(context).pop();
      } catch (e) {
        Navigator.of(context).pop();
        showErrorMessage(context, 'Some error happened: ${e.toString()}');
      }
      setState(() => _isLoading = false);
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
