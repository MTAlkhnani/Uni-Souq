import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
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
  List<File> _images = []; // Variable to store the selected images
  bool _isLoading = false; // Add a loading state
  // Future<File?> handleImageConversion(File imageFile) async {
  //   final String imagePathLowerCase = imageFile.path.toLowerCase();

  //   // Check if the image is in HEIC/HEIF format
  //   if (imagePathLowerCase.endsWith('.heic') ||
  //       imagePathLowerCase.endsWith('.heif')) {
  //     final tmpDir = (await getTemporaryDirectory()).path;
  //     final targetPath = '$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg';

  //     // Convert to JPG
  //     final result = await FlutterImageCompress.compressAndGetFile(
  //       imageFile.path,
  //       targetPath,
  //       format: CompressFormat.jpeg,
  //       quality: 90,
  //     );

  //     if (result == null) {
  //       // Handle conversion error
  //       print("Error converting HEIC/HEIF image to JPEG");
  //       return null;
  //     }
  //     return result;
  //   }

  // // Return the original image if no conversion is needed
  // return imageFile;
  // }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _images = pickedImages.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  Future<List<String?>> _uploadImages(List<File> images) async {
    List<String?> downloadUrls = [];

    for (File image in images) {
      String fileName =
          'products/${DateTime.now().millisecondsSinceEpoch}_${images.indexOf(image)}.png';
      try {
        final ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(image);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print(e);
        downloadUrls.add(null);
      }
    }

    return downloadUrls;
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must not close the dialog manually
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
          'description': _descriptionController.text,
          'sellerID': getCurrentUserUid(),
          'category': _selectedCategory,
          'condition': _selectedCondition,
          'user': "N/A", // Assuming this is additional info, adjust as needed
          'itemID': itemId,
          'imageURLs':
              validImageUrls, // Changed to 'imageURLs' to reflect it's a list
        });

        Navigator.of(context).pop(); // Dismiss the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully')));
      } catch (e) {
        Navigator.of(context).pop(); // Dismiss the loading dialog on error
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Some error happened: ${e.toString()}')));
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
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
                    onPressed: _pickImages,
                    child: Text('Add Pictures'),
                  ),
                  _images.isNotEmpty
                      ? SizedBox(
                          height: 200, // Adjust the height as necessary
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  3, // Adjust based on your design needs
                              childAspectRatio:
                                  1, // Adjust aspect ratio based on your design needs
                            ),
                            itemCount: _images.length,
                            itemBuilder: (context, index) {
                              File image = _images[index];
                              return Stack(
                                alignment: Alignment
                                    .topRight, // Position the remove button at the top right
                                children: [
                                  Image.file(image,
                                      fit: BoxFit.cover), // The image
                                  // The remove button
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.red), // 'X' icon
                                    onPressed: () {
                                      setState(() {
                                        _images.removeAt(
                                            index); // Remove the image from the list
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Container(), // Show an empty container if no images are selected
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _submitProduct, // Disable button when loading
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
}
