import 'package:flutter/material.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:unisouq/utils/size_utils.dart';

class PaymentPage extends StatefulWidget {
  final String sellerID;
  final String productName;
  final String condition;
  final String description;
  final String productId;
  final double currentPrice;
  final List<String> imageUrl; // Add imageUrl field

  PaymentPage({
    required this.sellerID,
    required this.productName,
    required this.condition,
    required this.description,
    required this.productId,
    required this.currentPrice,
    required this.imageUrl, // Initialize imageUrl field
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethod = 'Cash';
  bool _sendingInProgress = false;

  late double enteredPrice = widget.currentPrice;
  TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).method),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Card(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display item image at the top
                Center(
                  child: Image.network(
                    widget.imageUrl.isNotEmpty ? widget.imageUrl[0] : '',
                    fit: BoxFit.cover,
                    height: 250.h,
                    // Adjust the height as needed
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Price: ${widget.currentPrice.toStringAsFixed(2)} SAR",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          labelText: S.of(context).listprice,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            enteredPrice = double.parse(value);
                          }
                        },
                        controller: _priceController,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.of(context).prefcard,
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        value: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value.toString();
                          });
                        },
                        isDense: false,
                        items: ['Cash', 'Card']
                            .map((method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                ))
                            .toList(),
                        dropdownColor: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.8),
                        decoration: InputDecoration(
                          labelText: S.of(context).PaymentMethod,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          clipBehavior: Clip.antiAlias,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.v, horizontal: 85.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Increase shape here
                            ),
                          ),
                          onPressed: () {
                            String priceText = _priceController.text;

                            if (priceText.isNotEmpty) {
                              enteredPrice = double.parse(priceText);
                            }

                            // Call the method to send request to the seller
                            _sendRequestToSeller(
                                widget.sellerID,
                                widget.productName,
                                widget.condition,
                                widget.description,
                                enteredPrice,
                                widget.productId,
                                _paymentMethod);
                          },
                          child: Text(
                            S.of(context).SubmittheRequest,
                            style: TextStyle(
                                fontSize: 18.h,
                                color: Theme.of(context).bottomAppBarColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendRequestToSeller(
      String sellerID,
      String productName,
      String condition,
      String description,
      double listingPrice,
      String productId,
      String paymentmothed) {
    setState(() {
      _sendingInProgress = true; // Set sending progress flag
    });

    ChatService()
        .sendRequest(sellerID, productName, condition, description,
            listingPrice, productId, paymentmothed)
        .then((_) {
      // Request sent successfully, show a confirmation dialog or perform other actions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).Success),
            content: Text(S.of(context).suumassage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      // Handle errors if request sending fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(S.of(context).errormassagge),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }).whenComplete(() {
      // Reset sending progress after request is sent or failed
      setState(() {
        _sendingInProgress = true;
      });
    });
  }
}
