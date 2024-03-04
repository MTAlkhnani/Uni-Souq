import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/theme/settings_controller.dart';
import 'package:unisouq/utils/size_utils.dart';

class UniSouqApp extends StatefulWidget {
  final SettingsController settingsController;

  const UniSouqApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  @override
  _UniSouqAppState createState() => _UniSouqAppState();
}

class _UniSouqAppState extends State<UniSouqApp> {
  late ThemeData _lightTheme;
  late ThemeData _darkTheme;

  @override
  void initState() {
    _lightTheme = _buildLightTheme();
    _darkTheme = _buildDarkTheme();
    super.initState();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromRGBO(142, 108, 239, 1),
      hintColor: const Color.fromARGB(211, 29, 29, 29),
      canvasColor: Colors.black87,
      cardColor: Colors.black,
      hoverColor: const Color.fromRGBO(142, 108, 239, 1),
      scaffoldBackgroundColor: Colors.white,
      secondaryHeaderColor: const Color.fromRGBO(244, 244, 244, 1),
      bottomAppBarColor: const Color.fromRGBO(244, 244, 244, 1),
      iconTheme: IconThemeData(color: Colors.indigo[800]),
      textTheme: TextTheme(
        bodyText1: const TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.grey[800]),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color.fromRGBO(113, 66, 169, 1),
      hintColor: Colors.white,
      canvasColor: Colors.black87,
      cardColor: Colors.white,
      scaffoldBackgroundColor: const Color.fromRGBO(29, 24, 42, 1),
      secondaryHeaderColor: const Color.fromRGBO(52, 47, 63, 1),
      hoverColor: Colors.white38,
      iconTheme: IconThemeData(color: Colors.deepPurple[300]),
      shadowColor: Colors.white,
      bottomAppBarColor: const Color.fromRGBO(244, 244, 244, 1),
      textTheme: TextTheme(
        bodyText1: const TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.grey[300]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final settingsController = ref.watch(settingsControllerProvider);
        final currentLocale = settingsController.currentLocale;

        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            locale: Locale(currentLocale),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: _lightTheme,
            darkTheme: _darkTheme,
            themeMode: settingsController.themeMode,
            initialRoute: AppRoutes.initialRoute,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        });
      },
    );
  }
}
