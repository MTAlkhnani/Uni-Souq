import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import 'package:unisouq/screens/order_information/order_information.dart';
import 'package:unisouq/service/notification_service.dart';
import 'package:unisouq/utils/auth_utils.dart';
import 'package:unisouq/utils/size_utils.dart';

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
        title: Text(S.of(context).Request),
      ),
      body: FutureBuilder<String?>(
        future: clientId,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitWave(
              color: Colors.white,
              size: 50.0,
            );
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
          return const SpinKitWave(
            color: Colors.white,
            size: 50.0,
          );
        }

        List<DocumentSnapshot> requestDocs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: requestDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot request = requestDocs[index];
            String message = request['message'];
            String clientId = request['clientId'];
            String itemId = request['ItemId'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Item')
                  .doc(itemId)
                  .get(),
              builder: (context, itemSnapshot) {
                if (itemSnapshot.connectionState == ConnectionState.waiting) {
                  const SpinKitWave(
                    color: Colors.white,
                    size: 50.0,
                  );
                }

                if (itemSnapshot.hasError) {
                  return Text('Error: ${itemSnapshot.error}');
                }

                bool isItemSold = itemSnapshot.data?['status'] == 'Sold';

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
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      child: ListTile(
                        title: Text(message),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Client ID: $clientId"),
                            if (!isItemSold)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _handleAccept(
                                          context,
                                          message,
                                          request['clientId'],
                                          request['sellerID']);
                                    },
                                    child: Text(S.of(context).Accept),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showRejectionReasonDialog(context,
                                          request); // Pass the DocumentSnapshot
                                    },
                                    child: Text(
                                      S.of(context).Reject,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 193, 45, 34)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _contactClient(context, clientId);
                                    },
                                    child: Text(
                                      S.of(context).ContactClient,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 59, 186, 63)),
                                    ),
                                  ),
                                ],
                              ),
                            if (isItemSold)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _contactClient(context, clientId);
                                    },
                                    child: Text(
                                      S.of(context).ContactClient,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 59, 186, 63)),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Handle item removal action
                                      _removeItem(context, request.id);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                ],
                              )
                          ],
                        ),
                        onTap: () {
                          _showRequestSnackbar(context, message,
                              request['clientId'], request['sellerID']);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showRequestSnackbar(
      BuildContext context, String message, String clientId, String sellerID) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: S.of(context).Accepted,
          onPressed: () {
            // Handle accept action
            _handleAccept(context, message, clientId, sellerID);
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
          title: Text(S.of(context).Selectrejection),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...rejectionReasons.map((reason) => ListTile(
                    title: Text(reason),
                    onTap: () {
                      _sendRejectionMessage(request['sellerID'],
                          request['ItemId'], request['clientId'], reason);
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
                    hintText: S.of(context).Entercustomreason,
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
                  _sendRejectionMessage(request['sellerID'], request['ItemId'],
                      request['clientId'], customReason);
                  Navigator.pop(context);
                  // Delete the request document from Firestore
                  FirebaseFirestore.instance
                      .collection('requests')
                      .doc(request.id)
                      .delete();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(S.of(context).Pleaselist),
                    ),
                  );
                }
              },
              child: Text(S.of(context).Confirm),
            ),
          ],
        );
      },
    );
  }

  void _sendRejectionMessage(
      String sellerId, String itemId, String clientId, String massage) {
    String rejectionMessage = massage;
    String status = 'rejected'; // Use a string to represent the status

    // Use Firestore to send the rejection message
    FirebaseFirestore.instance.collection('responses').add({
      "sellerID": sellerId,
      'clientId': clientId,
      'productName': null, // Pass the product name
      'itemId': itemId,
      'responseMessage': rejectionMessage,
      'status': status, // Use the string status
      'timestamp': Timestamp.now(),
    }).then((value) async {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("usertoken")
          .doc(clientId)
          .get();
      String tokenresever = snap['token'];

      sendPushMessage(
          tokenresever, sellerId, rejectionMessage, 'responses', clientId);
      print('Rejection message sent successfully.');
    }).catchError((error) {
      print('Failed to send rejection message: $error');
    });
  }

  // Modify _handleAccept method to navigate to the order information screen
  void _handleAccept(
      BuildContext context, String message, String clientId, String sellerID) {
    String status = 'accepted';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderInformationScreen(
          message: message,
          clientId: clientId,
          sellerID: sellerID,
          state: status,
        ),
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

  void _removeItem(BuildContext context, String itemId) {
    // Remove the item document from the Firestore collection
    FirebaseFirestore.instance
        .collection('Item')
        .doc(itemId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item removed successfully.'),
        ),
      );
    }).catchError((error) {
      print('Error removing item: $error'); // Add debug logging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove item: $error'),
        ),
      );
    });
  }
}
