import 'package:flutter/material.dart';

import 'package:order_tracker/order_tracker.dart';
import 'package:unisouq/utils/size_utils.dart';

class OrderTrackerDemo extends StatefulWidget {
  const OrderTrackerDemo({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<OrderTrackerDemo> createState() => _OrderTrackerDemoState();
}

class _OrderTrackerDemoState extends State<OrderTrackerDemo> {
  List<TextDto> InitialOrderDataList = [
    TextDto("Your order has been inprogress", ""),
  ];

  List<TextDto> OrderShippedDataList = [
    TextDto("Your order has been accepted", ""),
  ];

  List<TextDto> OrderOutOfDeliveryDataList = [
    TextDto("Your order is shipped", ""),
  ];

  List<TextDto> OrderDeviveredDataList = [
    TextDto("Your order has been delivered", ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: OrderTracker(
                status: Status.shipped,
                activeColor: Theme.of(context).primaryColor,
                inActiveColor: Theme.of(context).cardColor.withOpacity(0.1),
                orderTitleAndDateList: InitialOrderDataList,
                shippedTitleAndDateList: OrderShippedDataList,
                outOfDeliveryTitleAndDateList: OrderOutOfDeliveryDataList,
                deliveredTitleAndDateList: OrderDeviveredDataList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
