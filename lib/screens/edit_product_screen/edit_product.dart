import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unisouq/components/custom_snackbar.dart';
import 'package:path/path.dart' as Path;
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/utils/size_utils.dart';

class EditProductScreen extends StatefulWidget {
  late final Map<String, dynamic> productData;

  EditProductScreen({required this.productData});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  late List<String> _categories;
  late List<String> _conditions;
  String? _selectedCategory;
  String? _selectedCondition;
  List<String> _imageUrls = [];
  bool _isLoading = false;

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

  @override
  void dispose() {
    super.dispose();
  }

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
    List<String> _translatedCategories =
        _categories.map((category) => _translateToEnglish(category)).toList();
    List<String> _translatedConditions = _conditions
        .map((condition) => _translateToEnglishcondtion(condition))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).EditProduct),
        actions: const [
          // IconButton(
          //   icon: Icon(Icons.delete),
          //   onPressed: () {
          //     _deleteItem(widget.productData['itemID']);
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
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
                ElevatedButton(
                  onPressed: _showBottomSheet,
                  child: Text(S.of(context).addnewpictures),
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
                  items: _translatedCategories
                      .toSet() // Convert to set to remove duplicates
                      .toList() // Convert back to list
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
                  hint: Text(S.of(context).SelectCategory),
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value;
                    });
                  },
                  items: _translatedConditions
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
                  decoration:
                      InputDecoration(labelText: S.of(context).DiscountedPrice),
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
                  child: Text(S.of(context).SaveChanges),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _updateProduct() async {
    if (_formKey.currentState!.validate() && _imageUrls.isNotEmpty) {
      setState(() => _isLoading = true);
      _showLoadingDialog();

      try {
        // Filter out URLs from _imageUrls
        List<File> files = _imageUrls
            .where((item) => item is File)
            .map<File>((item) => item as File)
            .toList();

        // Upload images
        final List<String?> downloadUrls = await _uploadImagesUpdate(files);

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
          showSuccessMessage(context, S.of(context).Productupdatedsuccessfully);
        } else {
          // No document found with the given itemID
          Navigator.of(context).pop();
          showErrorMessage(context, S.of(context).NoproductitemID);
        }
      } catch (error) {
        Navigator.of(context).pop();
        showErrorMessage(context, 'Some error happened: ${error.toString()}');
      }

      setState(() => _isLoading = false);
    }
  }

  void _deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('Item').doc(itemId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).Itemdeletedsuccessfully),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: ${error.toString()}'),
        ),
      );
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile> pickedImages = await _picker.pickMultiImage(
      imageQuality: 5,
    );

    if (pickedImages != null && pickedImages.isNotEmpty) {
      final List<File> compressedFiles =
          await Future.wait(pickedImages.map((xFile) async {
        final XFile? compressedXFile = await compressFile(xFile);
        return File(compressedXFile!.path);
      }));

      setState(() {
        _images = _images + compressedFiles;
      });
    }
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
  }

  Future<List<String?>> _uploadImagesUpdate(List<dynamic> images) async {
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
