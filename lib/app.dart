// UniSouqApp.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/routes/app_routes.dart';
import 'package:unisouq/theme/settings_controller.dart';
import 'package:unisouq/utils/size_utils.dart';

class UniSouqApp extends ConsumerWidget {
  final SettingsController settingsController;

  const UniSouqApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        final ThemeData lightTheme = ThemeData(
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

        final ThemeData darkTheme = ThemeData(
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

        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsController.themeMode,
            initialRoute: AppRoutes.initialRoute,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        });
      },
    );
  }
}
