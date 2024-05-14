import 'package:flutter/material.dart';
import 'package:order_tracker/order_tracker.dart';
import 'package:unisouq/utils/size_utils.dart';

class OrderTrackerDemo extends StatefulWidget {
  const OrderTrackerDemo({
    Key? key,
    required this.title,
    required this.orderStatus,
  }) : super(key: key);

  final String title;
  final String orderStatus;

  @override
  State<OrderTrackerDemo> createState() => _OrderTrackerDemoState();
}

class _OrderTrackerDemoState extends State<OrderTrackerDemo> {
  late List<TextDto> orderTitleAndDateList;
  late final Status ordeStatus;
  @override
  void initState() {
    super.initState();
    _updateOrderStatusList();
  }

  void _updateOrderStatusList() {
    switch (widget.orderStatus) {
      case 'order':
        ordeStatus = Status.order;
        orderTitleAndDateList = [
          TextDto("Your order has been in progress", DateTime.now().toString()),
        ];
        break;
      case 'shipped':
        ordeStatus = Status.shipped;
        // You can define a logic to set a date few days after 'order'
        // based on your order processing time
        orderTitleAndDateList = [
          TextDto("Your order has been shipped",
              DateTime.now().subtract(const Duration(days: 2)).toString()),
        ];
        break;
      case 'outOfDelivery':
        ordeStatus = Status.outOfDelivery;
        // You can define a logic to set a date few days after 'shipped'
        // based on your delivery time
        orderTitleAndDateList = [
          TextDto("Your order is out for delivery",
              DateTime.now().subtract(const Duration(days: 1)).toString()),
        ];
        break;
      case 'delivered':
        ordeStatus = Status.delivered;
        orderTitleAndDateList = [
          TextDto("Your order has been delivered", DateTime.now().toString()),
        ];
        break;
      default:
        ordeStatus = Status.order;
        orderTitleAndDateList = [
          TextDto("Your order has no status", ""),
        ];
    }
  }

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
                status: ordeStatus,
                activeColor: Theme.of(context).primaryColor,
                inActiveColor: Theme.of(context).cardColor.withOpacity(0.1),
                orderTitleAndDateList: orderTitleAndDateList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
