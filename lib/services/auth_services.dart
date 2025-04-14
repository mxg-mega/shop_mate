import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/local/user_storage.dart';
import 'package:shop_mate/data/models/auth_session_state.dart';
import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/data/models/users/user_model.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/services/storage_services.dart';
import 'package:shop_mate/services/business_service.dart';

import '../core/error/my_exceptions.dart';

import '../data/models/users/employee_model.dart';

class MyAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final MyAuthService _instance = MyAuthService._internal();

  factory MyAuthService() => _instance;

  MyAuthService._internal();

  Stream<AuthSessionState> get authSessionStream async* {
    yield AuthSessionState.loading();

    await for (User? user in _auth.authStateChanges()) {
      if (user == null) {
        yield AuthSessionState.unauthenticated();
      } else {
        try {
          final userModel = await _fetchUserModel(user.uid);
          if (userModel.businessID == null) {
            yield AuthSessionState.error('User has no associated business');
            continue;
          }
          final businessModel =
              await _fetchBusinessModel(userModel.businessID!);

          yield AuthSessionState.authenticated(userModel, businessModel);
        } catch (e) {
          yield AuthSessionState.error(e.toString());
          await _auth.signOut();
        }
      }
    }
  }

  Future<UserModel> _fetchUserModel(String uid) async {
    final doc = await _firestore.collection(Storage.users).doc(uid).get();
    return UserModel.fromJson(doc.data()!);
  }

  Future<Business> _fetchBusinessModel(String businessId) async {
    final doc =
        await _firestore.collection(Storage.businesses).doc(businessId).get();
    return Business.fromJson(doc.data()!);
  }

  Future<void> _persistSessionData(UserModel user, Business? business) async {
    await Future.wait([
      UserStorage.setUser(user.toJson()),
      if (business != null) BusinessStorage.setBusiness(business.toJson()),
    ] as Iterable<Future>);
  }

  Future<void> clearSessionData() async {
    await Future.wait([
      UserStorage.logout(),
      BusinessStorage.logout(),
    ]);
  }

  /// Registers new users
  static UserModel createUserModel({
    required String? id,
    required String email,
    required String password,
    required String name,
    required UserRole role,
    required String phoneNumber,
    String? businessID,
    required String? profilePicture,
  }) {
    final hashedPassword = UserModel.hashPassword(password);
    final newUserModel = UserModel(
      id: id!,
      name: name,
      email: email,
      password: hashedPassword,
      role: role,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      businessID: businessID ?? BusinessService.instance.businessId ?? '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );
    logger.e("created the UserMode: ${newUserModel.toString()}");
    return newUserModel;
  }

  // --------------------------
  // 1. Firebase Auth (Admins/Customers)
  // --------------------------
  Future<User?> signInAdminCustomer(String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user.user;
    } catch (e) {
      rethrow;
    }
  }

  // --------------------------
  // 2. Employee Auth
  // --------------------------
  Future<Employee> signInEmployee(
      String username, String businessId, String password) async {
    try {
      final employeesService = FirebaseCRUDService<Employee>(
        collectionName: Storage.employees,
        fromJson: (json) => Employee.fromJson(json),
      );
      final employeeDoc = await employeesService.collection
          .where(
            'username',
            isEqualTo: username,
          )
          .get();

      if (employeeDoc.docs.isEmpty) {
        throw AuthException('not-found', "Employee not found");
      }

      final employee = Employee.fromJson(employeeDoc.docs.first.data());
      if (!UserModel.verifyPassword(password, employee.password)) {
        throw AuthException("wrong-password", "Invalid Credentials");
      }

      return employee;
    } on FirebaseException catch (e) {
      throw AuthException(e.code, "Employee sign-in failed");
    }
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      // call authenticator to register user
      // a user credential class is the return type of the registration method
      print('Firebase Auth: Creating User ....');
      UserCredential? newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('FireBase Auth: Successfully created a new user: ${newUser.user}');
      // after getting the credential we get the user class and return it
      return newUser.user;
    } catch (e) {
      print('Error Registering User: $e \n By User/Auth Service');
      return null;
    }
  }

  /// Sign in with email and password.
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(userCredential.user.toString());
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signUpWithBusiness({
    required String email,
    required String password,
    required UserModel userModel,
  }) async {
    final businessModel = BusinessService.instance.currentBusiness;
    if (businessModel == null) {
      throw AuthException('no-business', 'No business selected');
    }

    try {
      final user = await registerUser(email, password);
      if (user == null) {
        throw AuthException('signup-failed', 'User creation failed');
      }

      final updatedUser = userModel.copyWith(id: user.uid);
      final updatedBusiness =
          (businessModel ?? BusinessService.instance.currentBusiness)
              ?.copyWith(ownerId: user.uid);
      if (updatedBusiness == null) {
        throw AuthException('no-business', 'No business selected');
      }

      await Future.wait([
        _firestore
            .collection(Storage.users)
            .doc(user.uid)
            .set(updatedUser.toJson()),
        _firestore
            .collection(Storage.businesses)
            .doc(updatedBusiness.id)
            .set(updatedBusiness.toJson()),
      ]);

      await _persistSessionData(updatedUser, updatedBusiness);
    } catch (e) {
      await clearSessionData();
      rethrow;
    }
  }

  /// Sign out the user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get the current user.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Listen for auth state changes.
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent.');
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      debugPrint('Verification email sent.');
    }
  }

  bool isEmailVerified() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.emailVerified ?? false;
  }
}
