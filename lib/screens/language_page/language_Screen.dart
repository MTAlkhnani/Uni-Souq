import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/generated/l10n.dart';
import 'package:unisouq/theme/settings_controller.dart';
import 'package:unisouq/utils/size_utils.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Langtheme),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        child: LanguageSelection(),
      ),
    );
  }
}

class LanguageSelection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsController = ref.watch(settingsControllerProvider);

    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(S.of(context).selectLanguage),
              onTap: () => _showLanguageDialog(context, settingsController),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(S.of(context).Theme),
              onTap: () => _showThemeDialog(context, settingsController),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(
      BuildContext context, SettingsController settingsController) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: SizedBox(
                  height: 20,
                  width: 20,
                  child: CountryFlag.fromLanguageCode('en')),
              title: Text(S.of(context).English),
              onTap: () => _updateLocale(context, settingsController, 'en'),
            ),
            ListTile(
              leading: SizedBox(
                  height: 20,
                  width: 20,
                  child: CountryFlag.fromLanguageCode('ar-sa')),
              title: Text(S.of(context).Arabic),
              onTap: () => _updateLocale(context, settingsController, 'ar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showThemeDialog(
      BuildContext context, SettingsController settingsController) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).SelectTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(S.of(context).SystemTheme),
              onTap: () =>
                  _updateTheme(context, settingsController, ThemeMode.system),
            ),
            ListTile(
              title: Text(S.of(context).LightTheme),
              onTap: () =>
                  _updateTheme(context, settingsController, ThemeMode.light),
            ),
            ListTile(
              title: Text(S.of(context).DarkTheme),
              onTap: () =>
                  _updateTheme(context, settingsController, ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateLocale(BuildContext context,
      SettingsController settingsController, String localeCode) async {
    await settingsController.updateLocale(localeCode);
    Navigator.pop(context);
  }

  Future<void> _updateTheme(BuildContext context,
      SettingsController settingsController, ThemeMode themeMode) async {
    await settingsController.updateThemeMode(themeMode);
    Navigator.pop(context);
  }
}
