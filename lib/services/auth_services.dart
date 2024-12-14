import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/services/firebase_services.dart';
import 'package:shop_mate/services/storage_services.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final StorageServices _storageServices = StorageServices();
  // final File defaultProfilePic = File(kImages.defaultProfilePic);

  final FirebaseService<UserModel> userService;

  /// Constructor
  AuthService(this.userService);

  /// Registers new users
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required RoleTypes role,
    required String phoneNumber,
    required String businessID,
    required String? profilePicture,
  }) async {
    final hashedPassword = UserModel.hashPassword(password);
    final newUser = UserModel(
      id: _firestore.collection('users').doc().id,
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

    await userService.create(newUser);
  }

  /// Sign in with email and password.
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Authenticates a user by email and password.
  Future<UserModel?> authenticateUser({
    required String email,
    required String password,
  }) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('User not found');
    }

    final userDoc = querySnapshot.docs.first;
    final user = userService.fromJson(userDoc.data() as Map<String, dynamic>);

    if (UserModel.verifyPassword(password, user.password)) {
      return user;
    } else {
      throw Exception('Invalid credentials');
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
