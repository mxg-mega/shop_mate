import 'package:flutter/material.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';

class LoginController {
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final bizNameController = TextEditingController();
  final addressController = TextEditingController();
  final bizEmailController = TextEditingController();
  final bizPhoneNumberController = TextEditingController();

  UserRole role = UserRole.none;
  BusinessCategories businessCategory = BusinessCategories.none;

  void dispose() {
    pwController.dispose();
    emailController.dispose();
    bizEmailController.dispose();
    bizNameController.dispose();
    bizPhoneNumberController.dispose();
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
  }
}
