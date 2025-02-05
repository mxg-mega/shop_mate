import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/services/firebase_CRUD_service.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/services/storage_services.dart';

import '../core/error/my_exceptions.dart';
import '../models/users/employee_model.dart';

class MyAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Constructor
  MyAuthService();

  /// Registers new users
  UserModel createUserModel({
    required String id,
    required String email,
    required String password,
    required String name,
    required UserRole role,
    required String phoneNumber,
    required String businessID,
    required String? profilePicture,
  }) {
    final hashedPassword = UserModel.hashPassword(password);
    final newUserModel = UserModel(
      id: id,
      name: name,
      email: email,
      password: hashedPassword,
      role: role,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      businessID: businessID,
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
      final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password,);

      return credential.user;
    } on FirebaseException catch (e) {
      throw AuthException(e.code, "Admin/Customer SignIn-Failed");
    }
  }

  // --------------------------
  // 2. Employee Auth
  // --------------------------
  Future<Employee> signInEmployee(String username, String businessId,
      String password) async {
    try {
      final employeesService = FirebaseCRUDService<Employee>(
          collectionName: Storage.employees,
          fromJson: (json) => Employee.fromJson(json),
          businessId: businessId);
      final employeeDoc = await employeesService.collection.where(
        'username', isEqualTo: username,).get();

      if(employeeDoc.docs.isEmpty){
        throw AuthException('not-found', "Employee not found");
      }

      final employee = Employee.fromJson(employeeDoc.docs.first.data());
      if (!UserModel.verifyPassword(password, employee.password)) {
        throw AuthException("wrong-password", "Invalid Credentials");
      }

      return employee;

    } on FirebaseException catch (e){
      throw AuthException(e.code, "Employee sign-in failed");
    }
  }

  Future<User?> registerUser(String email, String password) async {
    // in a Try catch block
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
      print(userCredential.user.toString());
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
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
      print('Password reset email sent.');
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print('Verification email sent.');
    }
  }

  bool isEmailVerified() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.emailVerified ?? false;
  }


}
