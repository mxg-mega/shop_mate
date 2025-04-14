import 'package:flutter/foundation.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/models/businesses/business_model.dart';

class BusinessService with ChangeNotifier {
  static final BusinessService _instance = BusinessService._internal();
  factory BusinessService() => _instance;
  BusinessService._internal() {
    // Initialize business ID from storage
    initialize();
  }

  Business? _currentBusiness;
  String? _businessId;

  Business? get currentBusiness => _currentBusiness;
  String? get businessId => _businessId;

  static BusinessService get instance => _instance;

  Future<void> initialize() async {
    final business = await BusinessStorage.getBusinessProfile();
    if (business != null) {
      _currentBusiness = business;
      _businessId = business.id;
      notifyListeners();
    }
  }

  Future<void> updateBusiness(Business updatedBusiness,
      {bool notify = true}) async {
    if (_currentBusiness == null || _businessId == null) {
      throw Exception("No business currently set to update.");
    }

    _currentBusiness = updatedBusiness;
    _businessId = updatedBusiness.id;

    await BusinessStorage.setBusiness(updatedBusiness.toJson());

    if (notify) notifyListeners();
  }

  Future<void> setBusiness(Business business) async {
    _currentBusiness = business;
    _businessId = business.id;
    BusinessStorage.setBusiness(business.toJson());
    notifyListeners();
  }

  Future<void> clearBusiness() async {
    _currentBusiness = null;
    _businessId = null;
    await BusinessStorage.logout();
    notifyListeners();
  }
}
