import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/data/models/token_generator.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';

class BusinessServices {
  static final BusinessServices _instance = BusinessServices._internal();

  factory BusinessServices() => _instance;

  BusinessServices._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseCRUDService<Business> businessService = FirebaseCRUDService(
    collectionName: Storage.businesses,
    fromJson: (data) => Business.fromJson(data),
    isSubcollection: false,
    // businessID: BusinessStorage.getBusinessProfile()?.id ?? ''
  );
  // final MyFirebaseService<Business> businessService = MyFirebaseService(
  //   collectionName: Storage.businesses,
  //   fromJson: (data) => Business.fromJson(data),
  // );

  // businessService.businessId = BusinessStorage.getBusinessProfile().id!;

  Future<Business> fetchBusiness(String id) async {
    try {
      final response = await businessService.read(id);
      return response!;
    } catch (e) {
      throw Exception('Failed to fetch business');
    }
  }

  static int id = 0;

  static Business createBusiness({
    required String name,
    required String email,
    required String phone,
    required String address,
    required BusinessCategories businessType,
    required String ownerID,
  }) {
    final newBusiness = Business(
      id: FirebaseFirestore.instance.collection(Storage.businesses).doc().id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      businessType: businessType,
      token: generateToken(),
      ownerId: ownerID,
    );
    logger.d("Created BusinessModel: ${newBusiness.toString()}");
    return newBusiness;
  }

  Future<Business?> getBusinessByName(String name) async {
    try {
      return await businessService.readByName(name);
    } catch (e) {
      throw Exception("Failed to get by name");
    }
  }

  Future<Business> getBusinessById(String id) async {
    logger.d("Fetching Business....");
    try {
      logger.d(id);
      if (id.isEmpty) {
        throw Exception('Empty id');
      }
      final bizInfo = await businessService.read(id);
      if (bizInfo == null) {
        throw Exception("business was not found");
      }
      debugPrint("${bizInfo.toJson()}");
      return bizInfo;
    } catch (e) {
      logger.e("Failed to fetch biz: $e");
      throw Exception("Could not get Biz");
    }
  }

  Future<Business> updateBusiness(
      String id, Map<String, dynamic> updates) async {
    try {
      await businessService.update(id, updates: updates);
      final biz = await businessService.read(id);
      if (biz == null) {
        throw Exception("Error Updating business");
      }
      return biz;
    } catch (e) {
      throw Exception("Could not update business");
    }
  }

  Future<void> saveToFirebase(Business bizModel) async {
    logger.d("Saving business to firestore......");
    try {
      await businessService.create(bizModel);
      logger.d("Successfully saved business to firebase!!");
    } catch (e) {
      logger.e("Failed to save business model to firebase");
      throw Exception("Failed to save to firebase");
    }
  }

  Future<QuerySnapshot> fetchBusinessByAbbrev(String businessAbbrev) async {
    try {
      QuerySnapshot businessQuery = await FirebaseFirestore.instance
          .collection(Storage.businesses)
          .where('businessAbbrev', isEqualTo: businessAbbrev)
          .get();
      if (businessQuery.docs.isEmpty) {
        throw Exception('Business not found.');
      }
      return businessQuery;
    } catch (e) {
      throw Exception('${e.toString()}');
    }
  }
}
