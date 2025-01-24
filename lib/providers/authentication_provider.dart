import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/businesses/business_model.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/services/auth_services.dart';
import 'package:shop_mate/services/business_services.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/services/storage_services.dart';
import 'package:shop_mate/services/user_services.dart';

import '../models/users/employee_model.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isLoading = false;
  bool showSignIn = true;
  String errorMessage = '';

  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final bizNameController = TextEditingController();
  final addressController = TextEditingController();
  final bizEmailController = TextEditingController();
  final bizPhoneNumberController = TextEditingController();

  UserRole selectedRole = UserRole.customer;

  Map<String, dynamic> bizInfo = {};
  Map<String, dynamic> userInfo = {};

  BusinessCategories selectedBusinessCategory = BusinessCategories.other;

  final authService = MyAuthService();

  final bizService = BusinessServices();

  final userServices = UserServices();

  bool get isLoading => _isLoading;

  void setRole(UserRole role) {
    selectedRole = role;
  }

  void setCategory(BusinessCategories category) {
    selectedBusinessCategory = category;
  }

  void signInToggle() {
    showSignIn = !showSignIn;
    notifyListeners();
  }

/*  Future<void> signIn(String identifier, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (identifier.contains('@') && !identifier.contains('.com')) {
        // Employee Login
        final parts = identifier.split('@');
        final username = parts[0];
        final businessName = parts[1];

        // Fetch business
        Business? business = await bizService.getBusinessByName(businessName);
        if (business == null) throw Exception('Business not found.');

        // Validate employee
        Employee? employee = business.employees.firstWhere(
              (e) => e.name == username && UserModel.verifyPassword(password, e.password),
          orElse: () => null,
        );
        if (employee == null) throw Exception('Invalid employee credentials.');

        logger.d("Employee logged in: ${employee.name}");
        // Set session for employee
        Provider.of<SessionProvider>(context, listen: false).setSession(
          role: RoleTypes.staff,
          userId: employee.id,
          businessId: business.id,
        );
      } else if (identifier.contains('.com')) {
        // Admin or Customer Login
        User? firebaseUser = await authService.signIn(identifier, password);
        if (firebaseUser == null) throw Exception('Invalid admin credentials.');

        logger.d("Admin logged in: ${firebaseUser.email}");
        // Fetch user data
        UserModel? user = await UserServices().fetchUserModel(firebaseUser.uid);
        if (user == null) throw Exception('User data not found.');

        // Set session for admin
        Provider.of<SessionProvider>(context, listen: false).setSession(
          role: user.role,
          userId: user.id,
          businessId: user.businessID,
        );
      } else {
        throw Exception("Invalid identifier format.");
      }
    } catch (e) {
      logger.e("Sign-in error: $e");
      ErrorToaster(
        context: context,
        message: "Login Failed",
        description: e.toString(),
        isDestructive: true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }*/

  Future<void> signInEmployee(
      String identifier, String password, BuildContext context) async {
    final parts = identifier.split('@');
    final username = parts[0];
    final businessName = parts[1];

    // Fetch business
    QuerySnapshot businessQuery = await FirebaseFirestore.instance
        .collection(Storage.businesses)
        .where('name', isEqualTo: businessName)
        .get();
    if (businessQuery.docs.isEmpty) throw Exception('Business not found.');

    // final businessId = businessQuery.docs.first.id;
    final businessId = await bizService.getBusinessByName(businessName);
    if (businessId == null)
      throw Exception("Cannot find business with identifier $businessName");

    // Fetch employee
    QuerySnapshot employeeQuery = await FirebaseFirestore.instance
        .collection(Storage.employees)
        .where('businessId', isEqualTo: businessId)
        .where('name', isEqualTo: username)
        .get();
    if (employeeQuery.docs.isEmpty) throw Exception('Employee not found.');

    final employeeData =
        employeeQuery.docs.first.data() as Map<String, dynamic>;
    final employeeModel = Employee.fromJson(employeeData);

    // Verify password
    if (!UserModel.verifyPassword(password, employeeData['password'])) {
      throw Exception('Invalid credentials.');
    }

    // Set session
    Provider.of<SessionProvider>(context, listen: false).setSession(
      role: UserRole.staff,
      userId: employeeQuery.docs.first.id,
      businessId: businessId.id,
      userData: employeeData,
      userModel: employeeModel,
    );

    print("Employee signed in: ${employeeData['name']}");
  }

  Future<void> signInAdminCustomer(String email, String password,
      BuildContext context, dynamic sessionProvider) async {
    try {
      User? firebaseUser = await authService.signIn(email, password);
      if (firebaseUser == null) throw Exception('Invalid credentials.');

      // Fetch user data
      /*DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(Storage.users)
          .doc(firebaseUser.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;*/

      final userModel = await userServices.getUserData(firebaseUser.uid);
      if (userModel == null)
        throw Exception("Unable to get user with id: ${firebaseUser.uid}");

      // Set session
      sessionProvider.setSession(
        role: userModel.role,
        userId: firebaseUser.uid,
        businessId: userModel.businessID,
        userData: userModel.toJson(),
        userModel: userModel,
      );

      print("Admin/Customer signed in: ${firebaseUser.email}");
    } catch (e) {
      print("Sign-in error: $e");
      ErrorNotificationService.showErrorToaster(
      message: "Login Failed",
      description: e.toString(),
      isDestructive: true,
    );
    }
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      logger.d("Saving User to fireStore....");
      await FirebaseFirestore.instance
          .collection(Storage.users)
          .doc(user.id)
          .set(user.toJson());
      logger.d("User saved successfully: ${user.id}");
    } catch (e, stackTrace) {
      logger.e("Error saving user: $e");
      logger.e(stackTrace);
      rethrow; // Re-throw the error if needed for higher-level handling.
    }
  }

  /// Create user, userModel, businessModel and link them together
  Future<void> signUp(
    BuildContext context,
    String email,
    String password,
    String name,
    String phoneNumber,
    UserRole role, {
    String? businessName,
    String? businessAddress,
    String? businessPhone,
    String? businessEmail,
    BusinessCategories? businessCategory,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 5));

      // Sign up user using firebase
      User? newFireBaseUser = await authService.registerUser(email, password);

      if (newFireBaseUser != null) {
        // Step 2: Create UserModel
        String userID = newFireBaseUser.uid;
        UserModel newUserModel = authService.createUserModel(
          id: userID,
          email: email,
          password: password,
          name: name,
          role: role,
          phoneNumber: phoneNumber,
          businessID: '',
          profilePicture: kImages.defaultProfilePic,
        );
        // Save user to database(FireStore)
        await saveUserToFirestore(newUserModel);

        // Step 3: Handle Business Creation (if admin role)
        if (role == UserRole.admin) {
          Business newBusiness = bizService.createBusiness(
            name: businessName!,
            email: businessEmail ?? email,
            phone: businessPhone ?? phoneNumber,
            address: businessAddress!,
            businessType: businessCategory!,
            ownerID: newFireBaseUser.uid,
          );

          newUserModel.businessID = newBusiness.id;
          await userServices.updateUserInfo(
              newFireBaseUser.uid, newUserModel.toJson());
          SessionProvider().setSession(
              role: newUserModel.role,
              userId: newUserModel.id,
              userModel: newUserModel,
          );

          if (role == UserRole.admin) bizService.saveToFirebase(newBusiness);
        }
        // Success
        logger.e("User signed up successfully: ${newUserModel.toJson()}");
        ErrorNotificationService.showErrorToaster(
      message: "Signup Successfully",
      isDestructive: true,
    );
      }
    } catch (e) {
      errorMessage = e.toString();
      print("Error during sign-up: $e");
      ErrorNotificationService.showErrorToaster(
      message: "Signup Failed",
      description: e.toString(),
      isDestructive: true,
    );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pwController.dispose();
    emailController.dispose();
    bizEmailController.dispose();
    bizNameController.dispose();
    bizPhoneNumberController.dispose();
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
