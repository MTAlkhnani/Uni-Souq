import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/models/firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:unisouq/routes/app_routes.dart';

import 'package:unisouq/utils/pref_utils.dart';
import 'package:unisouq/utils/size_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
    PrefUtils().init()
  ]).then((value) {
    runApp(ProviderScope(child: UniSouq()));
  });
}

class UniSouq extends ConsumerWidget {
  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    return Sizer(builder: (context, orientation, deviceType) {
      // Define light theme data
      final ThemeData lightTheme = ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue[300], // Adjust to match light theme water drop color
        hintColor: Colors.blue[800], // Adjust to match light theme accent color
        scaffoldBackgroundColor: Colors.white, // White background color
        iconTheme: IconThemeData(color: Colors.blue[800]), // Adjust to match light theme icon color
        textTheme: TextTheme(
          // Customize text theme to match light theme styles
          bodyText1: TextStyle(color: Colors.blue[800]),
          bodyText2: TextStyle(color: Colors.grey[800]),
          // Other text styles...
        ),
        // Other theme properties...
      );

      // Define dark theme data
      final ThemeData darkTheme = ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[800], // Adjust to match dark theme water drop color
        hintColor: Colors.cyanAccent[700], // Adjust to match dark theme accent color
        scaffoldBackgroundColor: Colors.black, // Black background color
        iconTheme: IconThemeData(color: Colors.blueGrey[300]), // Adjust to match dark theme icon color
        textTheme: TextTheme(
          // Customize text theme to match dark theme styles
          bodyText1: TextStyle(color: Colors.blueGrey[300]),
          bodyText2: TextStyle(color: Colors.grey[300]),
          // Other text styles...
        ),
        // Other theme properties...
      );

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme, // Set light theme here
        darkTheme: darkTheme, // Set dark theme here
        themeMode: ThemeMode.system, // Use system theme mode
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
      );
    });
  }
}