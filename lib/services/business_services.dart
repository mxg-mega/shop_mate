import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/businesses/business_model.dart';
import 'package:shop_mate/models/token_generator.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';

import 'package:shop_mate/services/firebase_services.dart';

class BusinessServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MyFirebaseService<Business> businessService = MyFirebaseService(
      collectionName: Storage.businesses,
      fromJson: (data) => Business.fromJson(data));

  static int id = 0;

  Business createBusiness({
    required String name,
    required String email,
    required String phone,
    required String address,
    required BusinessCategories businessType,
    required String ownerID,
  }) {
    final newBusiness = Business(
      id: _firestore.collection(Storage.businesses).doc().id,
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
    // if (id == null) {
    //   throw Exception(
    //       "Business ID cannot be null.\n - business Getter By Business Services.");
    // }
    try {
      logger.d("$id");
      final bizInfo = await businessService.read(id);
      if (bizInfo == null){
        throw Exception("business was not found");
      }
      return bizInfo;
    } catch (e) {
      logger.e("Failed to fetch biz: $e");
      throw Exception("Could not get Biz");
    }
  }

  Future<Business> updateBusiness(String id, Map<String, dynamic> updates) async {
    try {
      await businessService.update(id, updates);
      final biz = await businessService.read(id);
      if (biz == null){
        throw Exception("Error Updating business");
      }
      return biz;
    }catch (e){
      throw Exception("Could not update business");
    }
  }

  void saveToFirebase(Business bizModel) async {
    logger.d("Saving business to firestore......");
    try {
      await businessService.create(bizModel);
      logger.d("Successfully saved business to firebase!!");
    } catch (e) {
      logger.e("Failed to save business model to firebase");
      throw Exception("Failed to save to firebase");
    }
  }
}
