import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/models/businesses/business_model.dart';
import 'package:shop_mate/models/businesses/business_settings.dart';
import 'package:shop_mate/services/business_services.dart';
import 'package:shop_mate/services/user_services.dart';

import '../core/utils/constants.dart';
import '../models/base_model.dart';
import '../core/utils/constants_enums.dart';
import '../models/users/user_model.dart';

class SessionProvider with ChangeNotifier {
  bool isLoading = false;
  // Session details
  String? _userId;
  String? _businessId;
  UserRole? _role;
  Map<String, dynamic>? _userData;
  UserModel? _userModel;
  Business? _business;
  BusinessSettings? _businessSettings;
  Map<String, dynamic> collections = {
    'user': null,
    'business': null,
    'sales': null,
    'inventory': null,
    'employees': null,
  };

  // Firebase services
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _userServices = UserServices();
  final _bizServices = BusinessServices();

  // Getters
  String? get userId => _userId;
  String? get businessId => _businessId;
  UserModel? get userModel => _userModel;
  Business? get business => _business;
  BusinessSettings? get businessSettings => _businessSettings;
  UserRole? get role => _role;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoggedIn => _userId != null;
  Stream<User?> get firebaseAuthStream => auth.authStateChanges();
  Stream<bool> get customSessionStream => _customSessionStreamController.stream;

  // Fetch role-specific flags
  bool get isAdmin => _role == UserRole.admin;
  bool get isStaff => _role == UserRole.staff;
  bool get isCustomer => _role == UserRole.customer;

  // StreamController for custom session management
  final StreamController<bool> _customSessionStreamController =
      StreamController.broadcast();

  // Initialize session state
  Future<void> initializeSession() async {
    isLoading = true;
    notifyListeners();
    try {
      final user = auth.currentUser;
      if (user != null) {
        // Fetch user data from Firestore
        final userDoc = await _userServices.getUserData(user.uid);
        

        if (userDoc != null) {
          _userData = userDoc.toJson();
          _userId = user.uid;
          _role = userDoc.role;
          _businessId = userDoc.businessID;

          try {
            // Fetch Business Details from firestore
            final bizDoc =
                await _bizServices.getBusinessById(userDoc.businessID!);
            _business = bizDoc;
            _businessSettings = bizDoc?.businessSettings;
          } catch (e) {
            print('Error fetching business: $e');
          }
        }
      } else {
        // Check for custom employee session
        if (_role == UserRole.staff) {
          _customSessionStreamController.add(true);
        } else {
          _customSessionStreamController.add(false);
        }
      }
    } catch (e) {
      print("Error initializing session: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Set session data after login
  void setSession({
    required UserRole role,
    required String userId,
    String? businessId,
    Map<String, dynamic>? userData,
    required dynamic userModel,
  }) {
    print("Setting Session with user ${userModel.toJson()}");
    _role = role;
    _userId = userId;
    _businessId = businessId;
    _userData = userData;
    _userModel = userModel;
    _customSessionStreamController.add(true);
    notifyListeners();
  }

  // Clear session on logout
  Future<void> clearSession() async {
    try {
      await auth.signOut();
    } catch (e) {
      print("Error during sign-out: $e");
    }
    _userId = null;
    _businessId = null;
    _role = null;
    _userData = null;
    _userModel = null;
    _customSessionStreamController.add(false);
    notifyListeners();
  }

  // Role-based access control
  bool hasAccess(String feature) {
    const rolePermissions = {
      UserRole.admin: ['manage_inventory', 'view_sales', 'manage_employees'],
      UserRole.staff: ['record_sales', 'view_inventory'],
      UserRole.customer: ['view_purchases', 'chat'],
    };
    return rolePermissions[_role]?.contains(feature) ?? false;
  }

  // Listen for authentication state changes
  void listenToAuthChanges() {
    auth.authStateChanges().listen((user) async {
      if (user == null) {
        clearSession();
      } else {
        await initializeSession();
      }
    });
  }

  // Dispose stream controller
  @override
  void dispose() {
    _customSessionStreamController.close();
    super.dispose();
  }
}
