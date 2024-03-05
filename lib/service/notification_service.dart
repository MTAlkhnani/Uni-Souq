// Import the NotificationService class
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unisouq/main.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/screens/massaging_screan/massage_page.dart';
import 'package:unisouq/utils/auth_utils.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final _massaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Assuming _massaging is an instance of some messaging service.

  static Future<void> intt() async {
    await _massaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<void> saveToken() async {
    final token = await _massaging.getToken();

    // Check if the token already exists in the usertoken collection
    final tokenSnapshot = await FirebaseFirestore.instance
        .collection('usertoken')
        .where('token', isEqualTo: token)
        .get();

    if (tokenSnapshot.docs.isEmpty) {
      // Token doesn't exist, retrieve UserId from the User collection
      final userId = await getUserId();
      final userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('UserId',
              isEqualTo: userId) // Assuming getUserId() gets the UserId
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        // Save the token in the usertoken collection under the corresponding UserId
        await FirebaseFirestore.instance
            .collection('usertoken')
            .doc(userId)
            .set({
          'token': token,
          'UserId': userId
          // Add other fields if needed
        });
      }
    }
  }

// Initialize local notifications
  static Future localNotiInit() async {
    // Initialize Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize Darwin initialization settings
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        // Handle local notifications received while the app is in the foreground
        // You can add custom logic here if needed
        return null;
      },
    );

    // Initialize Linux initialization settings
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    // Initialize initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    // Initialize Flutter local notifications plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        // Handle tap on notification while the app is in the foreground or background
        // Extract the payload and pass it to the appropriate method
        onNotificationTap(jsonDecode(payload as String));
      },
    );
  }

  static void onNotificationTap(Map<String, dynamic> notificationData) {
    // Extract necessary data from the payload
    final String? notificationType = notificationData['notificationType'];
    final String? receiverUserID = notificationData['receiverUserID'];

    // Determine the action based on notification type
    if (notificationType == 'message' && receiverUserID != null) {
      // Delay pushing the new route by 100 milliseconds
      Future.delayed(Duration(milliseconds: 100), () {
        // Navigate to MessagingPage with the receiverUserID
        navigaotorkey.currentState!.push(
          MaterialPageRoute(
            builder: (_) => MessagingPage(
              receiverUserID: receiverUserID,
            ),
          ),
        );
      });
    } else {
      // Delay pushing the new route by 100 milliseconds
      Future.delayed(Duration(milliseconds: 100), () {
        // Handle other notification types or fallback to default behavior
        navigaotorkey.currentState!.pushNamed(
          AppRoutes.requestpage,
          arguments: notificationData,
        );
      });
    }
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
    String? notificationType, // Additional data to include in the payload
    String? receiverUserID, // Additional data to include in the payload
  }) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'high Important Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Construct payload with additional data
    Map<String, dynamic> notificationData = {
      'title': title,
      'body': body,
      'notificationType': notificationType,
      'receiverUserID': receiverUserID,
    };

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(notificationData),
    );
  }
}
