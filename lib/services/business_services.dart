import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/businesses/business_model.dart';
import 'package:shop_mate/models/token_generator.dart';
import 'package:shop_mate/models/users/constants_enums.dart';

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
    required ownerID,
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

    // try {
    //   print('FirebaseService creating and storing business....');
    //   print('NewBusiness: ${_newBusiness!.toJson()}');
    //   // await businessService.create(_newBusiness!);
    //   print('Sucessfully Created a Business: ${_newBusiness!.toJson()}');
    // } catch (e) {
    //   print('failed to create a Business : $e, \n By BusinessServices');
    // }
  }

  Future<Business?> getBusinessByName(String name) async {
    try {
      return await businessService.readByName(name);
    } catch (e) {
      throw Exception("Failed to get by name");
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
