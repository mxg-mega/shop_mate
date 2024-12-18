import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/businesses/business_model.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/services/auth_services.dart';
import 'package:shop_mate/services/business_services.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/services/storage_services.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isLoading = false;
  bool showSignIn = true;

  final pwController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  RoleTypes selectedRole = RoleTypes.customer;

  Map<String, dynamic> bizInfo = {};
  Map<String, dynamic> userInfo = {};

  TextEditingController bizNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bizEmailController = TextEditingController();
  TextEditingController bizPhoneNumberController = TextEditingController();
  BusinessCategories selectedBusinessCategory = BusinessCategories.other;

  final authService = AuthService(
    FirebaseService<UserModel>(
      collectionName: Storage.users,
      fromJson: (data) => UserModel.fromJson(data),
    ),
  );

  final bizService = BusinessServices(
    FirebaseService<Business>(
      collectionName: Storage.businesses,
      fromJson: (data) => Business.fromJson(data),
    ),
  );

  bool get isLoading => _isLoading;

  void setRole(RoleTypes role) {
    selectedRole = role;
  }

  void setCategory(BusinessCategories category) {
    selectedBusinessCategory = category;
  }

  void signInToggle() {
    showSignIn = !showSignIn;
    notifyListeners();
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Simulate network request
      await Future.delayed(Duration(seconds: 2));
      // Handle authentication logic
      await authService.signIn(email, password);
      print("User signed in with $email");
    } catch (e) {
      print("Error signing in: $e");
      ErrorToaster(
          context: context,
          message: 'Verification Failed',
          description: 'Error Signing in',
          isDestructive: true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(
      Map<String, dynamic> userInfo, Map<String, dynamic> businessInfo) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get default profile picture if not provided
      userInfo['profilePicture'] ??=
          'assets/images/default_profile_picture.png';

      // Create Business Model
      bizService.createBusiness(
        name: businessInfo['name'],
        email: businessInfo['email'] ?? userInfo['email'],
        phone: businessInfo['phoneNumber'] ?? userInfo['phoneNumber'],
        address: businessInfo['address'],
        businessType: businessInfo['type'],
      );

      // Create user and register them including the id of the business
      authService.createUser(
        email: userInfo['email'],
        password: userInfo['password'],
        name: userInfo['name'],
        role: userInfo['role'],
        phoneNumber: userInfo['phoneNumber'],
        businessID: bizService.newBusiness.id,
        profilePicture: userInfo['profilePicture'],
      );
    } catch (e) {
      print("Error signing up: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
