import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:unisouq/constants/constants.dart';
import 'package:unisouq/global.dart';
import 'package:unisouq/routes/app_routes.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String signOutText;
  final TextStyle titleTextStyle;
  final TextStyle contentTextStyle;
  final TextStyle buttonTextStyle;

  MyDialog({
    this.title = "Sign Out",
    this.content = "Are you sure you want to sign out?",
    this.cancelText = "Cancel",
    this.signOutText = "Sign Out",
    required this.titleTextStyle,
    required this.contentTextStyle,
    required this.buttonTextStyle,
    required void Function() onSignOutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoDialog(context)
        : _buildMaterialDialog(context);
  }

  Widget _buildCupertinoDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title,
        style: titleTextStyle ?? TextStyle(),
      ),
      content: Text(
        content,
        style: contentTextStyle ?? TextStyle(),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            cancelText,
            style: contentTextStyle ?? TextStyle(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          child: Text(
            signOutText,
            style: buttonTextStyle ?? TextStyle(),
          ),
          onPressed: () {
            _signOut(context);
          },
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: titleTextStyle ?? TextStyle(),
      ),
      content: Text(
        content,
        style: contentTextStyle ?? TextStyle(),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            cancelText,
            style: contentTextStyle ?? TextStyle(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            signOutText,
            style: buttonTextStyle ?? TextStyle(),
          ),
          onPressed: () {
            _signOut(context);
          },
        ),
      ],
    );
  }

  // Function to handle user sign-out
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to SignInScreen after signing out
    Global.storageService
        .setBool(AppConstrants.STORAGE_DEVICE_SING_IN_KEY, false);
    Navigator.popAndPushNamed(context, AppRoutes.signInScreen);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.signInScreen, (route) => false);

    // Clear the navigation stack so that the user can't navigate back to HomeScreen
  }
}
