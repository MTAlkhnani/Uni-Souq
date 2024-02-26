import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import 'package:unisouq/screens/order_information/order_information.dart';
import 'package:unisouq/utils/auth_utils.dart';

class RequestPage extends StatefulWidget {
  static const String id = 'request_page';

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  List<String> rejectionReasons = [
    'Not available',
    'Price too low',
    'Item already sold',
    'Other'
  ];
  String selectedReason = '';
  late Future<String?> clientId;

  @override
  void initState() {
    super.initState();
    clientId = getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request'),
      ),
      body: FutureBuilder<String?>(
        future: clientId,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Only build the request list if clientId is available
          return _buildRequestList(snapshot.data);
        },
      ),
    );
  }

  Widget _buildRequestList(String? clientId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('sellerID', isEqualTo: clientId) // Filter requests by sellerID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> requestDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: requestDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot request = requestDocs[index];
            String message = request['message'];
            String clientId = request['clientId'];

            return Dismissible(
              key: Key(request.id), // Unique key for each request
              onDismissed: (direction) {
                // Remove the item from Firestore when dismissed
                FirebaseFirestore.instance
                    .collection('requests')
                    .doc(request.id)
                    .delete();
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
              ),
              direction: DismissDirection.endToStart,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Card(
                  child: ListTile(
                    title: Text(message),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Client ID: $clientId'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _handleAccept(context, message);
                              },
                              child: const Text('Accept'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showRejectionReasonDialog(context,
                                    request); // Pass the DocumentSnapshot
                              },
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 193, 45, 34)),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _contactClient(context, clientId);
                              },
                              child: const Text(
                                'Contact Client',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 59, 186, 63)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      _showRequestSnackbar(context, message);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRequestSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Accept',
          onPressed: () {
            // Handle accept action
            _handleAccept(context, message);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _showRejectionReasonDialog(
      BuildContext context, DocumentSnapshot request) {
    TextEditingController customReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select or enter a reason for rejection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...rejectionReasons.map((reason) => ListTile(
                    title: Text(reason),
                    onTap: () {
                      _sendRejectionMessage(reason);
                      Navigator.pop(context);
                      // Delete the request document from Firestore
                      FirebaseFirestore.instance
                          .collection('requests')
                          .doc(request.id)
                          .delete();
                    },
                  )),
              ListTile(
                title: TextField(
                  controller: customReasonController,
                  decoration: InputDecoration(
                    hintText: 'Enter custom reason',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String customReason = customReasonController.text.trim();
                if (customReason.isNotEmpty) {
                  _sendRejectionMessage(customReason);
                  Navigator.pop(context);
                  // Delete the request document from Firestore
                  FirebaseFirestore.instance
                      .collection('requests')
                      .doc(request.id)
                      .delete();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Please enter a reason or select from the list.'),
                    ),
                  );
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _sendRejectionMessage(String reason) {
    // Implement your logic to send the rejection message to the client with the selected reason
  }
  // Modify _handleAccept method to navigate to the order information screen
  void _handleAccept(BuildContext context, String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderInformationScreen(message: message),
      ),
    );
  }

  void _contactClient(BuildContext context, String clientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingPage(receiverUserID: clientId),
      ),
    );
  }
}
