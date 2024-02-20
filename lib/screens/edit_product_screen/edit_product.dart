import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unisouq/components/custom_snackbar.dart';
import 'package:path/path.dart' as Path;

class EditProductScreen extends StatefulWidget {
  late final Map<String, dynamic> productData;

  EditProductScreen({required this.productData});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _discountPriceController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCondition;
  List<String> _imageUrls = [];
  bool _isLoading = false;

  List<String> _categories = [
    'Electronics',
    'Books',
    'Clothing',
    'Home',
    'Toys'
  ];

  List<String> _conditions = [
    'New',
    'Used - Like New',
    'Used - Good',
    'Used - Acceptable'
  ];

  List<File> _images = [];
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.productData['title'];
    _priceController.text = widget.productData['price'];
    _descriptionController.text = widget.productData['description'];
    _discountPriceController.text =
        widget.productData['discountedPrice'] ?? '0'; // Handle null case
    _selectedCategory = widget.productData['category'];
    _selectedCondition = widget.productData['condition'];

    // Retrieve image URLs from productData
    _imageUrls = List<String>.from(widget.productData['imageURLs']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Select Images'),
                ),
                _imageUrls.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                          ),
                          itemCount: _imageUrls.length,
                          itemBuilder: (context, index) {
                            String imageUrl = _imageUrls[index];
                            return Stack(
                              children: [
                                Image.network(imageUrl, fit: BoxFit.cover),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _imageUrls.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : Container(),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Select Category'),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
                  dropdownColor: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  hint: const Text('Select Condition'),
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value;
                    });
                  },
                  items:
                      _conditions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Please select a condition' : null,
                  dropdownColor: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _discountPriceController,
                  decoration:
                      const InputDecoration(labelText: 'Discounted Price'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _updateProduct(),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? pickedImages = await _picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        _images = pickedImages.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  _updateProduct() async {
    if (_formKey.currentState!.validate() && _imageUrls.isNotEmpty) {
      setState(() => _isLoading = true);
      _showLoadingDialog();

      try {
        // Upload images
        final List<String?> downloadUrls = await _uploadImages(_imageUrls);

        final List<String> validImageUrls = downloadUrls
            .where((url) => url != null)
            .map((url) => url!)
            .toList();

        // Use the existing product ID to update the document
        String itemId = widget.productData[
            'itemID']; // Assuming 'itemID' is a field within the document
        QuerySnapshot querySnapshot = await firestore
            .collection('Item')
            .where('itemID', isEqualTo: itemId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming there's only one document with the given itemID
          DocumentReference itemRef =
              firestore.collection('Item').doc(querySnapshot.docs.first.id);

          // Create a map to hold the updated data
          Map<String, dynamic> updatedData = {
            'title': _nameController.text,
            'price': _priceController.text,
            'discountedPrice': _discountPriceController.text,
            'description': _descriptionController.text,
            'category': _selectedCategory,
            'condition': _selectedCondition,
            'imageURLs': validImageUrls,
          };

          // Update the document with the new data
          await itemRef.update(updatedData);

          Navigator.of(context).pop();
          showSuccessMessage(context, "Product updated successfully");
        } else {
          // No document found with the given itemID
          Navigator.of(context).pop();
          showErrorMessage(
              context, 'No product found with the specified itemID.');
        }
      } catch (error) {
        Navigator.of(context).pop();
        showErrorMessage(context, 'Some error happened: ${error.toString()}');
      }

      setState(() => _isLoading = false);
    }
  }

  Future<List<String?>> _uploadImages(List<dynamic> images) async {
    List<String?> downloadUrls = [];

    try {
      for (File image in images) {
        if (image is String) {
          // If it's a URL, directly add it to downloadUrls
          downloadUrls.add(image as String?);
        } else if (image is File) {
          // If it's a File, upload it to Firebase Storage
          String fileName =
              'products/${DateTime.now().millisecondsSinceEpoch}_${images.indexOf(image)}.png';

          final ref = FirebaseStorage.instance.ref().child(fileName);
          await ref.putFile(image);
          String downloadUrl = await ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        } else {
          // Handle unsupported type
          print('Unsupported type: $image');
        }
      }
    } catch (e) {
      print('Upload failed: $e');
      // If an upload fails, add a placeholder image URL
      downloadUrls.add(
          'https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png');
    }

    return downloadUrls;
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
}
