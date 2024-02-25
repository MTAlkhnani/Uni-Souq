import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unisouq/app.dart';
import 'package:unisouq/global.dart';
import 'package:unisouq/models/firebase_options.dart';
import 'package:unisouq/theme/settings_controller.dart';
import 'package:unisouq/theme/settings_service.dart';
import 'package:unisouq/utils/pref_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    // Initialize FlutterLocalNotificationsPlugin
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
