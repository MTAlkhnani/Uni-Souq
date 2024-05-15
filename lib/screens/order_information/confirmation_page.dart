import 'package:flutter/material.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/utils/size_utils.dart';

enum ConfirmationType {
  order,
  request,
  // Add more confirmation types as needed
}

class ConfirmationPage extends StatelessWidget {
  static const String id = 'confirmation_page';

  final ConfirmationType confirmationType;

  const ConfirmationPage({
    Key? key,
    required this.confirmationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    String confirmationMessage;

    // Set title and confirmation message based on the confirmation type
    switch (confirmationType) {
      case ConfirmationType.order:
        title = S.of(context).OrderDecision;
        confirmationMessage = S.of(context).Yourorderhasbeenaccepted;
        break;
      case ConfirmationType.request:
        title = S.of(context).OrderDecision;
        confirmationMessage = S.of(context).suumassage;
        break;
      // Add more cases for additional confirmation types
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide the back button
        title: Center(child: Text(title)),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.v),
              child: Text(
                confirmationMessage,
                style: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.homeScreen, (route) => false);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors.green), // Change color as needed
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    11.0), // Adjust borderRadius as needed
              ),
            ),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                vertical: 16.0)), // Adjust padding as needed
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).Back,
                style: TextStyle(
                    color: ThemeData()
                        .scaffoldBackgroundColor), // Change text color as needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
