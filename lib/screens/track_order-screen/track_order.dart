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
          TextDto("Your order has been in progress", ""),
        ];
        break;
      case 'shipped':
        ordeStatus = Status.shipped;
        orderTitleAndDateList = [
          TextDto("Your order has been accepted", ""),
        ];
        break;
      case 'outOfDelivery':
        ordeStatus = Status.outOfDelivery;
        orderTitleAndDateList = [
          TextDto("Your order is shipped", ""),
        ];
        break;
      case 'delivered':
        ordeStatus = Status.delivered;
        orderTitleAndDateList = [
          TextDto("Your order has been delivered", ""),
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
