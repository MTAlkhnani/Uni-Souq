import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderInformationScreen extends StatelessWidget {
  final String message;

  const OrderInformationScreen({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Information'),
      ),
      body: OrderForm(message: message),
    );
  }
}

class OrderForm extends StatefulWidget {
  final String message;

  const OrderForm({Key? key, required this.message}) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.message),
            TextFormField(
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
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
                  decoration: InputDecoration(labelText: 'Pickup Time'),
                  controller: TextEditingController(
                    text: pickupTime == null
                        ? ''
                        : DateFormat.yMd().add_jm().format(pickupTime),
                  ),
                  validator: (value) {
                    if (pickupTime == null) {
                      return 'Please select a pickup time';
                    }
                    return null;
                  },
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Final Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
              onSaved: (value) {
                finalPrice = double.parse(value!);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _confirmOrder(context);
                }
              },
              child: Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPickupDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != pickupTime) {
      setState(() {
        pickupTime = pickedDate;
      });
    }
  }

  void _confirmOrder(BuildContext context) {
    final message =
        'Order confirmed: Location: $location, Pickup Time: $pickupTime, Final Price: $finalPrice';
    _sendReceipt(context, message);
  }

  void _sendReceipt(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Receipt'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
