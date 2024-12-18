import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/businesses/business_model.dart';
import 'package:shop_mate/models/token_generator.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/services/storage_services.dart';

class BusinessServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService<Business> businessService;
  var _newBusiness;

  Business get newBusiness => _newBusiness;

  BusinessServices(this.businessService);

  static int id = 0;

  Future<void> createBusiness({
    required String name,
    required String email,
    required String phone,
    required String address,
    required BusinessCategories businessType,
  }) async {
    _newBusiness = Business(
      id: _firestore.collection(Storage.businesses).doc().id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      businessType: businessType,
      token: generateToken(),
    );

    try {
      await businessService.create(_newBusiness);
    } catch (e) {
      print('failed to create a user : $e, \n By UserServices');
    }
  }
}
