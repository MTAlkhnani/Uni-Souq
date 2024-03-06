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
import 'package:http/http.dart' as http;
import 'package:unisouq/utils/auth_utils.dart';

typedef NotificationTapCallback = void Function(
    Map<String, dynamic> notificationData);

NotificationTapCallback? _notificationTapCallback;
void setNotificationTapCallback(NotificationTapCallback callback) {
  _notificationTapCallback = callback;
}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await _messaging.requestPermission(
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
    final token = await _messaging.getToken();

    final tokenSnapshot = await FirebaseFirestore.instance
        .collection('usertoken')
        .where('token', isEqualTo: token)
        .get();

    if (tokenSnapshot.docs.isEmpty) {
      final userId = await getUserId();
      final userSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('UserId', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('usertoken')
            .doc(userId)
            .set({
          'token': token,
          'UserId': userId,
        });
      }
    }
  }

  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        return null;
      },
    );

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) async {
        onNotificationTap(jsonDecode(payload as String));
      },
    );
  }

  static void onNotificationTap(Map<String, dynamic> notificationData) {
    _notificationTapCallback?.call(notificationData);
  }

  static Future showSimpleNotification({
    required int id,
    required String? title,
    required String? body,
    required NotificationDetails? notificationDetails,
    String? payload,
    String? notificationType,
    String? receiverUserID,
  }) async {
    if (kIsWeb) {
      return;
    }
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}

Future<void> handleNotificationTap(
  String userId,
  String title,
  String body,
  String notificationType,
) async {
  try {
    // Get a reference to the user's subcollection
    CollectionReference userNotificationsCollection = FirebaseFirestore.instance
        .collection('Notification')
        .doc(userId)
        .collection('UserNotifications');

    // Add the notification data to the user's subcollection
    await userNotificationsCollection.add({
      'title': title,
      'body': body,
      'notificationType': notificationType,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error handling notification tap: $e');
  }
}

void sendPushMessage(
  String token,
  String title,
  String body,
  String notificationType,
  String receiverUserID,
) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAA_jPfHp8:APA91bGzw4DQxr32meVuQ08ybbRmdUIWxg0-4uuAtIQyfw40vZvCVdT6JH2FA_-oXRg36mwn5fMf84H0eUJA1WTFe0KHfj05knNz1lR0lZAAVxdCA06tAvQsmsl3mOezVvCEP62jDt82',
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
            'notificationType': notificationType,
            'receiverUserID': receiverUserID,
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'android_channel_id': 'dbfood',
          },
          'to': token,
        },
      ),
    );
    await handleNotificationTap(receiverUserID, title, body, notificationType);
  } catch (e) {
    if (kDebugMode) print('Error sending push message: $e');
  }
}

void sendPushMessages(String token, String title, String body,
    String notificationType, String receiverUserID) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAA_jPfHp8:APA91bGzw4DQxr32meVuQ08ybbRmdUIWxg0-4uuAtIQyfw40vZvCVdT6JH2FA_-oXRg36mwn5fMf84H0eUJA1WTFe0KHfj05knNz1lR0lZAAVxdCA06tAvQsmsl3mOezVvCEP62jDt82',
      },
      body: jsonEncode(
        <String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
            'notificationType': notificationType,
            'receiverUserID': receiverUserID,
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'android_channel_id': 'dbfood',
          },
          'to': token,
        },
      ),
    );
    await handleNotificationTap(receiverUserID, title, body, notificationType);
  } catch (e) {
    if (kDebugMode) print('Error sending push message: $e');
  }
}
