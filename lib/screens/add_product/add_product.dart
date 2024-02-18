import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  bool _isLoading = false; // Add a loading state

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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });
      _showLoadingDialog(); // Show loading dialog
      try {
        // Add a new product to the "products" collection
        await FirebaseFirestore.instance.collection('Item').add({
          'title': _nameController.text,
          'price': _priceController.text,
          'description': _descriptionController.text,
          'sellerID': getCurrentUserUid(),
          'category': _selectedCategory,
          'condition': _selectedCondition,
          'user': "N/A"
        });

        Navigator.of(context).pop(); // Dismiss the loading dialog

        // Show a success message or perform other actions like clearing the form
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully')));
      } catch (e) {
        Navigator.of(context)
            .pop(); // Ensure the loading dialog is dismissed in case of an error
        // Handle errors or show an error message
      }

      setState(() {
        _isLoading = false; // End loading
      });
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
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
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
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
                  items:
                      _conditions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Please select a condition' : null,
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
    );
  }
}
