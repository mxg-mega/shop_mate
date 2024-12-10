import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool _isDarkMode = false;
  bool get isDarkTheme => _isDarkMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() async {
    final newMode =
        themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _isDarkMode = !_isDarkMode;
    setThemeMode(newMode);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      setThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
    }
  }
}
