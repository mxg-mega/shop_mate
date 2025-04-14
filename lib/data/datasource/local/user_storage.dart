import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_mate/data/models/users/user_model.dart';

import 'app_shared_preferences.dart';

class UserStorage {
  static final UserStorage _instance = UserStorage._internal();
  static final SharedPreferences _prefs = AppSharedPreference.prefs;

  factory UserStorage() => _instance;

  static String? _cachedUserId;

  static Future<void> initSharedPreferences() async {
    await AppSharedPreference.initSharedPreferences();
    if (isActivated()) {
      _cachedUserId = getUserProfile()?.id;
    }
  }

  static bool isActivated() => _prefs.containsKey('user');

  static String? get userId {
    if (_cachedUserId == null && isActivated()) {
      _cachedUserId = getUserProfile()?.id;
    }
    return _cachedUserId;
  }

  static Future<void> logout() async {
    _cachedUserId = null;
    await _prefs.remove('user');
  }

  static setUser(Map<String, dynamic> user) {
    _prefs.setString('user', json.encode(user));
    _cachedUserId = UserModel.fromJson(user).id;
  }

  static updateUser(Map<String, dynamic> updatedUser) async {
    await _prefs.remove('user');
    _prefs.setString('user', json.encode(updatedUser));
    _cachedUserId = UserModel.fromJson(updatedUser).id;
  }

  static Map<String, dynamic> getUser() {
    String userJson = _prefs.getString('user') ?? '';
    if (userJson.isEmpty) {
      return {};
    }
    try {
      return jsonDecode(userJson);
    } catch (e) {
      return {};
    }
  }

  static UserModel? getUserProfile() {
    Map<String, dynamic> userMap = getUser();
    return userMap.isNotEmpty ? UserModel.fromJson(userMap) : null;
  }

  static setUsername(String username) {
    _prefs.setString('username', username);
  }

  static String? getUsername() {
    return _prefs.getString('username');
  }

  Future<void> setEmail(String email) async {
    await _prefs.setString('saved_email', email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_email');
  }

  Future<void> clearEmail() async {
    await _prefs.remove('saved_email');
  }

  UserStorage._internal();
}
