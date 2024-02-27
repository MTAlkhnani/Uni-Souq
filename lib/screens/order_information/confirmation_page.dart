import 'package:flutter/material.dart';
import 'package:unisouq/routes/app_routes.dart';

class ConfirmationPage extends StatelessWidget {
  static const String id = 'confirmation_page';

  const ConfirmationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Accepted'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your order has been accepted!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.homeScreen, (route) => false);
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
