import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_service.dart';

final settingsControllerProvider =
    ChangeNotifierProvider((ref) => SettingsController(SettingsService()));

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService) {
    loadSettings(); // Call loadSettings() in the constructor
  }

  final SettingsService _settingsService;
  late ThemeMode _themeMode;
  late String _currentLocale = '';

  ThemeMode get themeMode => _themeMode;
  String get currentLocale => _currentLocale;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _currentLocale = await _settingsService.locale();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLocale(String newLocale) async {
    if (newLocale == _currentLocale) return;

    _currentLocale = newLocale;

    notifyListeners();

    await _settingsService.updateLocale(newLocale);
  }
}
