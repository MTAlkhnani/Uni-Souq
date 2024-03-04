import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unisouq/theme/settings_controller.dart'; // Import the file where settingsControllerProvider is defined

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
      ),
      body: LanguageSelection(),
    );
  }
}

class LanguageSelection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsController = ref.watch(settingsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('English'),
          onTap: () => _updateLocale(context, settingsController, 'en'),
        ),
        ListTile(
          title: const Text('Arabic'),
          onTap: () => _updateLocale(context, settingsController, 'ar'),
        ),
        // Add more languages as needed
      ],
    );
  }

  Future<void> _updateLocale(BuildContext context,
      SettingsController settingsController, String localeCode) async {
    await settingsController.updateLocale(localeCode);
    Navigator.pop(context);
  }
}
