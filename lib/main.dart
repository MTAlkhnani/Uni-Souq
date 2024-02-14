import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/models/firebase_options.dart';
import 'package:unisouq/global.dart';
import 'package:unisouq/theme/settings_controller.dart';
import 'package:unisouq/theme/settings_service.dart';

import 'package:unisouq/utils/pref_utils.dart';

import 'app.dart';

void main() async {
  // Ensure Flutter app is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize SharedPreferences
  await PrefUtils().init();

  // Initialize storage service
  await Global.init();

  // Initialize settings controller
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  // Run the app
  runApp(
    ProviderScope(
      child: UniSouqApp(settingsController: settingsController),
    ),
  );
}
