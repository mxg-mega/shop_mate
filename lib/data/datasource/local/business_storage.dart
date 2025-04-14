import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/services/business_services.dart';
import 'app_shared_preferences.dart';

class BusinessStorage {
  static final BusinessStorage _instance = BusinessStorage._internal();
  static final SharedPreferences _prefs = AppSharedPreference.prefs;

  factory BusinessStorage() => _instance;

  static String? _cachedBusinessId;

  static Future<void> initSharedPreferences() async {
    await AppSharedPreference.initSharedPreferences();
    if (isActivated()) {
      _cachedBusinessId = getBusinessProfile()?.id;
    }
  }

  static bool isActivated() => _prefs.containsKey('business');

  static String? get businessId {
    if (_cachedBusinessId == null && isActivated()) {
      _cachedBusinessId = getBusinessProfile()?.id;
    }
    return _cachedBusinessId;
  }

  static Future<void> logout() async {
    _cachedBusinessId = null;
    await _prefs.remove('business');
  }

  static setBusiness(Map<String, dynamic> business) {
    _prefs.setString('business', json.encode(business));
    _cachedBusinessId = Business.fromJson(business).id;
  }

  static updateBusiness(Map<String, dynamic> businessUpdate) async {
    await _prefs.remove('business');
    _prefs.setString('business', json.encode(businessUpdate));
    _cachedBusinessId = Business.fromJson(businessUpdate).id;
  }

  static Map<String, dynamic> getBusiness() {
    String businessJson = _prefs.getString('business') ?? '';
    if (businessJson.isEmpty) {
      return {};
    }
    try {
      return jsonDecode(businessJson);
    } catch (e) {
      return {};
    }
  }

  static Business? getBusinessProfile() {
    Map<String, dynamic> businessMap = getBusiness();
    // TODO: would it not be better to fetch from backend if the locally stored is empty?
    return businessMap.isNotEmpty ? Business.fromJson(businessMap) : null;
  }

  static setBusinessName(String name) {
    _prefs.setString('business_name', name);
  }

  static String? getBusinessName() {
    return _prefs.getString('business_name');
  }

  Future<void> setBusinessEmail(String email) async {
    await _prefs.setString('business_email', email);
  }

  Future<String?> getBusinessEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('business_email');
  }

  Future<void> clearBusinessEmail() async {
    await _prefs.remove('business_email');
  }

  BusinessStorage._internal();
}
