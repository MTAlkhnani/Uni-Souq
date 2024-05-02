import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:order_tracker/order_tracker.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/screens/massaging_screan/chat/chat_Service.dart';
import 'package:unisouq/screens/track_order-screen/track_order.dart';
import 'package:unisouq/utils/size_utils.dart';

class OrderDetailsPage extends StatefulWidget {
  final String responseMessage;
  final String itemId;
  final String imageURL;
  final String title;
  final String clientId;
  final String sellerId;

  OrderDetailsPage({
    required this.responseMessage,
    required this.itemId,
    required this.imageURL,
    required this.title,
    required this.clientId,
    required this.sellerId,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late bool _isClient = false;
  late bool _isRated = false;
  late double _rating = 0;
  TextEditingController _reviewController = TextEditingController();
  // Define a list of status options
  List<String> statusOptions = [
    'order',
    'shipped',
    'outOfDelivery',
    'delivered'
  ];

  // Define a variable to store the selected status
  late String selectedStatus = 'order'; // Initialize with default value

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchOrderStatus(widget.itemId);
  }

  Future<void> _fetchData() async {
    try {
      // Fetch other data (ratings, reviews, etc.)
      String getCurrentUserUid() {
        final User? user = FirebaseAuth.instance.currentUser;
        final String uid = user?.uid ?? "Not Signed In";
        return uid;
      }

      if (widget.clientId == getCurrentUserUid()) {
        setState(() {
          _isClient = true;
        });
        var snapshot = await FirebaseFirestore.instance
            .collection('Rating')
            .doc(widget.sellerId)
            .get();

        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          if (data['clientId'] == widget.clientId &&
              data['itemId'] == widget.itemId) {
            _rating = data['rating'];

            // Fetch and set the review if it exists
            _reviewController.text = data['review'] ?? '';
            setState(() {
              _isClient = true;
              _isRated = true;
            });
          }
        }
      } else {
        var sellerSnapshot = await FirebaseFirestore.instance
            .collection('Rating')
            .doc(widget.sellerId)
            .get();

        if (sellerSnapshot.exists) {
          Map<String, dynamic> sellerData =
              sellerSnapshot.data() as Map<String, dynamic>;
          _rating = sellerData['rating'];

          // Fetch and set the review if it exists
          _reviewController.text = sellerData['review'] ?? '';
          setState(() {
            _isRated = true;
          });
        }
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  Future<void> _fetchOrderStatus(String? itemId) async {
    try {
      // Query the orders collection for documents where 'itemid' matches itemId
      var snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('itemid', isEqualTo: itemId)
          .get();

      // Check if any documents match the query
      if (snapshot.docs.isNotEmpty) {
        // Extract the status field from the first document
        Map<String, dynamic> data = snapshot.docs.first.data();
        String status = data['status'];

        // Set the status as selectedStatus
        setState(() {
          selectedStatus = status;
        });
      } else {
        // Handle case where no matching document is found
        setState(() {
          selectedStatus = 'order'; // Or any default value you want to set
        });
        print('No order found with itemId: $itemId');
      }
      await _fetchData();
    } catch (e) {
      print('Error fetching order status: $e');
    }
  }

  Future<void> _updateOrderStatus(String status) async {
    try {
      // Query the orders collection for documents where 'itemid' matches itemId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('itemid', isEqualTo: widget.itemId)
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Loop through each document in the result
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          // Update the status field of each document
          await documentSnapshot.reference.update({
            'status': status,
          });
        }

        // Update the UI with the new status
        setState(() {
          selectedStatus = status;
        });

        print('Order status updated successfully.');
      } else {
        print('No order found with itemId: ${widget.itemId}');
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          child: Text(S.of(context).OrderDetails),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('itemid', isEqualTo: widget.itemId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.transparent
                              .withOpacity(0.1)), // Add border color here
                      borderRadius: BorderRadius.circular(
                          10.0), // Add border radius if needed
                    ),
                    child: ListTile(
                      leading: Image.network(
                        widget.imageURL,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        widget.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(widget.responseMessage),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_isRated || !_isRated) ...[
                        SizedBox(height: 10.v),
                        Text(
                          S.of(context).howitwas,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          S.of(context).SellerRating,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RatingBar.builder(
                            initialRating: _rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (_isClient == true)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.v, horizontal: 50.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    13.0), // Increase shape here
                              ),
                            ),
                            onPressed: () {
                              final ChatService chatService = ChatService();
                              String productIssueMessage =
                                  S.of(context).prodectissue;
                              chatService.contactSellerproblem(
                                context,
                                widget.sellerId,
                                productIssueMessage,
                              );
                            },
                            icon: const Icon(Icons.report),
                            label: Text(
                              S.of(context).ProductIssue,
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 15),
                            ),
                          ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).reviewd,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        if (_isClient == true)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.v),
                            child: TextField(
                              controller: _reviewController,
                              decoration: InputDecoration(
                                hoverColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(30),
                                filled: true,
                                fillColor: Colors.transparent.withOpacity(0.09),
                                hintText: S.of(context).enter,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors
                                          .transparent), // Change border color here
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                        if (!_isClient)
                          Column(
                            children: [
                              DropdownButton<String>(
                                value: selectedStatus,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      // Update selectedStatus immediately
                                      selectedStatus = newValue;
                                    });
                                    // Call _updateOrderStatus with newValue
                                    _updateOrderStatus(selectedStatus);
                                  }
                                },
                                items: statusOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.v),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent.withOpacity(
                                        0.09), // Set a transparent color
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      _reviewController.text.isNotEmpty
                                          ? _reviewController.text
                                          : S.of(context).no,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (_isClient == true)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.v),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13.0), // Increase shape here
                    ),
                  ),
                  onPressed: () {
                    if (_rating >= 0) {
                      try {
                        FirebaseFirestore.instance
                            .collection('Rating')
                            .doc(widget.sellerId)
                            .set({
                          'sellerId': widget.sellerId,
                          'clientId': widget.clientId,
                          'itemId': widget.itemId,
                          'rating': _rating,
                          'timestamp': DateTime.now(),
                          'review': _reviewController.text,
                        }).then((value) {
                          print(S.of(context).Ratingsubmittedsuccessfully);
                          Navigator.pop(context);
                        }).catchError((error) {
                          print("Failed to submit rating: $error");
                        });
                      } catch (error) {
                        print("Error submitting rating: $error");
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            S.of(context).Pleaseselectaratingbeforesubmitting,
                            style: const TextStyle(
                                color: Colors.white), // Adjust text color here
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).Submit,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight:
                                FontWeight.bold), // Adjust text color here
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(width: 12.h),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.v),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(13.0), // Increase shape here
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderTrackerDemo(
                        title: 'Order Tracker',
                        orderStatus: selectedStatus,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.track_changes,
                      color: Theme.of(context).primaryColor,
                      size: 25,
                    ),
                    SizedBox(
                      width: 5.h,
                    ),
                    Text(
                      S.of(context).trackorder,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
