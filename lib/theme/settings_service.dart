import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<void> updateThemeMode(ThemeMode theme) async {}

  Future<String> locale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('locale') ?? 'ar'; // Default locale code
  }

  Future<void> updateLocale(String localeCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', localeCode);
    print('Updated locale to: $localeCode');
  }
}

