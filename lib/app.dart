import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/models/firebase_options.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/theme/settings_controller.dart';

import 'package:unisouq/utils/size_utils.dart';

class UniSouqApp extends ConsumerWidget {
  final SettingsController settingsController;

  const UniSouqApp({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        final ThemeData lightTheme = ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color.fromRGBO(142, 108, 239, 1),
          hintColor: const Color.fromRGBO(39, 39, 39, 0.498),
          hoverColor: const Color.fromRGBO(142, 108, 239, 1),
          scaffoldBackgroundColor: Colors.white,
          secondaryHeaderColor: const Color.fromRGBO(244, 244, 244, 1),
          iconTheme: IconThemeData(color: Colors.indigo[800]),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.grey[800]),
          ),
        );

        final ThemeData darkTheme = ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromRGBO(142, 108, 239, 1),
          hintColor: Colors.white,
          scaffoldBackgroundColor: const Color.fromRGBO(29, 24, 42, 1),
          secondaryHeaderColor: const Color.fromRGBO(52, 47, 63, 1),
          hoverColor: Colors.white24,
          iconTheme: IconThemeData(color: Colors.deepPurple[300]),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.grey[300]),
          ),
        );

        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsController.themeMode,
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.routes,
          );
        });
      },
    );
  }
}
