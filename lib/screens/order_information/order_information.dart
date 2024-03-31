import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/screens/order_information/confirmation_page.dart';
import 'package:unisouq/service/notification_service.dart';
import 'package:unisouq/utils/auth_utils.dart';
import 'package:unisouq/utils/size_utils.dart';
import 'dart:math';

class OrderInformationScreen extends StatelessWidget {
  final String message;
  final String clientId;
  final String sellerID;
  final String state;

  const OrderInformationScreen({
    Key? key,
    required this.message,
    required this.clientId,
    required this.sellerID,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).OrderInformation),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('clientId', isEqualTo: clientId)
            .where('sellerID', isEqualTo: sellerID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            var data = snapshot.data!.docs;
            if (data.isNotEmpty) {
              var document = data.first;
              String clientId = document['clientId'];
              String sellerID = document['sellerID'];
              return OrderForm(
                message: message,
                clientId: clientId,
                sellerID: sellerID,
                productName: document['productName'],
                itemDetails: document['message'],
                orderId: document.id, // Pass the order ID
                state: state,
              );
            }
          }
          // You can return a loading indicator or error message here if needed
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class OrderForm extends StatefulWidget {
  final String message;
  final String clientId;
  final String sellerID;
  final String productName;
  final String itemDetails;
  final String orderId; // Add order ID to track the specific order
  final String state;

  const OrderForm(
      {Key? key,
      required this.message,
      required this.clientId,
      required this.sellerID,
      required this.productName,
      required this.itemDetails,
      required this.orderId,
      required this.state})
      : super(key: key);

  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  late String location;
  late DateTime pickupTime = DateTime.now(); // Initialize with current date
  late double finalPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h),
          child: Column(
            crossAxisAlignment: isArabic()
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              TextFormField(
                decoration: InputDecoration(labelText: S.of(context).Location),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).loc;
                  }
                  return null;
                },
                onSaved: (value) {
                  location = value!;
                },
              ),
              GestureDetector(
                onTap: () {
                  _selectPickupDate(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration:
                        InputDecoration(labelText: S.of(context).PickupTime),
                    controller: TextEditingController(
                      text: pickupTime == null
                          ? ''
                          : DateFormat.yMd().add_jm().format(pickupTime),
                    ),
                    validator: (value) {
                      if (pickupTime == null) {
                        return S.of(context).selectpick;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: S.of(context).FinalPrice),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return S.of(context).procev;
                  }
                  return null;
                },
                onSaved: (value) {
                  finalPrice = double.parse(value!);
                },
              ),
              SizedBox(height: 60.h),
              Center(
                child: SizedBox(
                  width: 400.v,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _confirmOrder(context, widget.itemDetails);
                      }
                    },
                    child: Text(S.of(context).ConfirmOrder),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectPickupDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != pickupTime) {
      setState(() {
        pickupTime = pickedDate;
      });
    }
  }

  Future<void> _sendReceipt(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).Receipt),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).OK),
            ),
          ],
        );
      },
    );
  }

  void _confirmOrder(BuildContext context, String itemDetails) async {
    final message =
        "Order confirmed: \nLocation: $location \nPickup Time: $pickupTime \nFinal Price: $finalPrice \n$itemDetails";
    _sendReceipt(context, message);

    // Fetch the document based on the productName
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Item')
        .where('title', isEqualTo: widget.productName)
        .limit(1) // Limit to 1 document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document
      var document = querySnapshot.docs.first;

      // Ensure that the document has the required fields
      if (document.exists) {
        // Access the data fields using null-aware operators or provide default values
        String? sellerID = document['sellerID'];
        String? productName = document['title'];

        // Retrieve the clientId and ItemId from the requests collection
        var clientData = await _fetchClientData(widget.productName);

        // Optionally provide default values if the fields are null
        sellerID ??= 'Default Seller ID';
        productName ??= 'Default Product Name';

        String? clientId = clientData['clientId'];
        String? itemId = clientData['itemId'];

        clientId ??= 'Default Client ID';
        itemId ??= 'Default Item ID';

        // Send response to the client
        await sendResponse(clientId, sellerID, productName, message, clientId,
            itemId, widget.state);

        // Update the order status to "Sold" in the Item collection
        await FirebaseFirestore.instance
            .collection('Item')
            .doc(itemId)
            .update({'status': 'Sold'});

// Update the order status in the orders collection
        await _updateOrderStatusInOrdersCollection(itemId, "order");
        // Navigate to the confirmation page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmationPage()),
        );
      } else {
        // Handle the case where the document does not exist
        print('Document does not exist for productName ${widget.productName}');
      }
    } else {
      // Handle the case where no document is found
      print('Document with productName ${widget.productName} not found');
    }
  }

  Future<Map<String, String?>> _fetchClientData(String productName) async {
    // Fetch the document from the requests collection based on productName
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('requests')
        .where('productName', isEqualTo: productName)
        .limit(1) // Limit to 1 document
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document
      var document = querySnapshot.docs.first;

      // Access the clientId and ItemId fields
      String? clientId = document['clientId'];
      String? itemId = document['ItemId'];

      return {'clientId': clientId, 'itemId': itemId};
    } else {
      // Handle the case where no document is found
      print(
          'Document with productName $productName not found in requests collection');
      return {'clientId': null, 'itemId': null};
    }
  }

  Future<void> sendResponse(
      String clientId,
      String sellerID,
      String productName,
      String responseMessage,
      String recipientClientId,
      String itemId,
      String state) async {
    try {
      // Send response to the client
      await FirebaseFirestore.instance.collection('responses').add({
        'clientId': clientId,
        'sellerID': sellerID,
        'productName': productName,
        'responseMessage': responseMessage,
        'recipientClientId': recipientClientId,
        'itemId': itemId,
        'status': state,
        'timestamp': Timestamp.now(),
      });
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("usertoken")
          .doc(clientId)
          .get();
      String tokenresever = snap['token'];

      sendPushMessage(
          tokenresever, sellerID, responseMessage, 'responses', clientId);
    } catch (e) {
      print('Failed to send response: $e');
      throw e;
    }
  }

  bool isArabic() {
    return Intl.getCurrentLocale() == 'ar';
  }

  Future<void> _updateOrderStatusInOrdersCollection(
      String orderId, String status) async {
    try {
      // Add a new document to the orders collection with the provided orderId and status
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'itemid': orderId,
        'status': status,
      });

      print('Order status added successfully.');
    } catch (error) {
      print('Error adding order status to orders collection: $error');
      // Handle error as needed
    }
  }
}
