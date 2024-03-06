import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unisouq/app.dart';
import 'package:unisouq/global.dart';
import 'package:unisouq/models/firebase_options.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import 'package:unisouq/service/notification_service.dart';
import 'package:unisouq/theme/settings_controller.dart';
import 'package:unisouq/theme/settings_service.dart';
import 'package:unisouq/utils/pref_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future _firebasemassaging(RemoteMessage message) async {
  if (message.notification != null) {
    print(" the massaging work");
  }
}

final navigaotorkey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter app is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Handle Firebase initialization errors
    print('Error initializing Firebase: $e');
    // Log error to a file or crash reporting service
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null && message.data != null) {
      String notificationType = message.data['notificationType'];
      String receiverUserID =
          message.data['receiverUserID']; // Extract receiverUserID

      if (notificationType == 'message') {
        // Navigate to MessagingPage with receiverUserID
        navigaotorkey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => MessagingPage(
              receiverUserID: receiverUserID,
            ),
          ),
        );
      } else if (notificationType == 'request') {
        // Handle request notification
        navigaotorkey.currentState!.pushNamed(AppRoutes.requestpage);
      } else if (notificationType == 'responses') {
        navigaotorkey.currentState!.pushNamed(AppRoutes.myorderpage);
      }
    }
  });

  NotificationService.init();
  NotificationService.localNotiInit();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Map<String, dynamic> payloadData = message.data;
    String receiverUserID = payloadData['receiverUserID'];
    String payloadJson = jsonEncode(payloadData);

    print("Received a message in the foreground");
    if (message.notification != null) {
      NotificationService.showSimpleNotification(
        id: 0,
        title: message.notification!.title,
        body: message.notification!.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: payloadJson,
        notificationType: payloadData['notificationType'],
        receiverUserID: receiverUserID,
      );
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebasemassaging);
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    // Initialize SharedPreferences
    await PrefUtils().init();
  } catch (e) {
    // Handle SharedPreferences initialization errors
    print('Error initializing SharedPreferences: $e');
    // Log error to a file or crash reporting service
  }

  try {
    // Initialize storage service
    await Global.init();
  } catch (e) {
    // Handle storage service initialization errors
    print('Error initializing storage service: $e');
    // Log error to a file or crash reporting service
  }

  try {
    // Initialize settings controller
    final settingsController = SettingsController(SettingsService());
    await settingsController.loadSettings();

    // Run the app
    runApp(
      ProviderScope(
        child: UniSouqApp(settingsController: settingsController),
      ),
    );
  } catch (e) {
    // Handle settings controller initialization errors
    print('Error initializing settings controller: $e');
    // Log error to a file or crash reporting service
  }
}
