import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Internet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.signal_wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can add code here to handle retrying the internet connection
                // For example, you can check the internet connection again and redirect to the appropriate page.
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
