import 'package:flutter/material.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';

class PaymentPage extends StatefulWidget {
  final String sellerID;
  final String productName;
  final String condition;
  final String description;
  final String productId;
  final double currentPrice;

  PaymentPage({
    required this.sellerID,
    required this.productName,
    required this.condition,
    required this.description,
    required this.productId,
    required this.currentPrice,
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
        title: const Text('Enter Price and Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Listing Price: ${widget.currentPrice.toStringAsFixed(2)} SAR',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Enter New Listing Price',
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      enteredPrice = double.parse(value);
                    }
                  },
                  controller: _priceController,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Payment Method:',
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
                  items: ['Cash', 'Card']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
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
                      );
                    },
                    child: const Text('Submit'),
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
  ) {
    setState(() {
      _sendingInProgress = true; // Set sending progress flag
    });

    ChatService()
        .sendRequest(sellerID, productName, condition, description,
            listingPrice, productId)
        .then((_) {
      // Request sent successfully, show a confirmation dialog or perform other actions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Your request has been sent successfully.'),
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
    }).catchError((error) {
      // Handle errors if request sending fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Failed to send request. Please try again later.'),
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
