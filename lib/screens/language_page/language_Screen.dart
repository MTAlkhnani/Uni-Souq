import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unisouq/generated/l10n.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    // Get the currently selected locale
    _selectedLocale = WidgetsBinding.instance!.window.locale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectLanguage),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('English'),
            onTap: () {
              _changeLanguage(const Locale('en'));
            },
            trailing: _selectedLocale.languageCode == 'en'
                ? const Icon(Icons.check)
                : null,
          ),
          ListTile(
            title: Text('Arabic'),
            onTap: () {
              _changeLanguage(const Locale('ar'));
            },
            trailing: _selectedLocale.languageCode == 'ar'
                ? const Icon(Icons.check)
                : null,
          ),
        ],
      ),
    );
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _selectedLocale = locale;
    });
    // Change the locale for the app
    S.load(locale);

    // Determine text direction based on the selected language
    TextDirection textDirection = TextDirection.ltr;
    if (locale.languageCode == 'ar') {
      textDirection = TextDirection.rtl;
    }

    // Update directionality by replacing the LanguageSelectionPage with updated directionality
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Directionality(
          textDirection: textDirection,
          child: LanguageSelectionPage(),
        ),
      ),
    );
  }
}
