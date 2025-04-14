
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreference {
  static final AppSharedPreference _mySharedPreference =
  AppSharedPreference._internal();
  static bool _sharedPreferencesLoaded = false;
  static late SharedPreferences prefs;

  factory AppSharedPreference() {
    return _mySharedPreference;
  }

  AppSharedPreference._internal() {
    AppSharedPreference();
  }

  static Future<void> initSharedPreferences() async {
    if (_sharedPreferencesLoaded) {
      return;
    }

    prefs = await SharedPreferences.getInstance();
    _sharedPreferencesLoaded = true;
  }
}