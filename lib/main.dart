import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/models/firebase_options.dart';
import 'package:unisouq/theme/settings_controller.dart';
import 'package:unisouq/theme/settings_service.dart';


import 'package:unisouq/utils/pref_utils.dart';

import 'app.dart';
// Import your SettingsController

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await PrefUtils().init();

  runApp(
    ProviderScope(
      child: UniSouqApp(settingsController: settingsController),
    ),
  );
}
