import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/error/my_exceptions.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/local/user_storage.dart';
import 'package:shop_mate/data/models/auth_session_state.dart';
import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/data/models/businesses/business_settings.dart';
import 'package:shop_mate/data/models/users/user_model.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/services/auth_services.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/business_services.dart';
import 'package:shop_mate/services/user_services.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _showSignIn = true;
  String errorMessage = '';

  Map<String, dynamic> bizInfo = {};
  Map<String, dynamic> userInfo = {};

  final authService = MyAuthService();
  final bizService = BusinessServices();
  final userServices = UserServices();

  bool get isLoading => _isLoading;
  bool get showSignIn => _showSignIn;

  void signInToggle() {
    _showSignIn = !_showSignIn;
    notifyListeners();
  }

  AuthSessionState _state = AuthSessionState.initial();
  get state => _state;
  User? _currentUser;
  UserModel? _currentUserData;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AuthSessionState> get authSessionStream async* {
    yield _state; // Yield current state immediately
    yield* authService.authSessionStream.asyncMap((user) async {
      if (user == null) {
        _state = AuthSessionState.unauthenticated();
      } else {
        _currentUserData = user.user;
        await initializeSession();
      }
      notifyListeners();
      return _state;
    });
  }

  BusinessSettings? _businessSettings;
  final BusinessService _businessService = BusinessService.instance;

  UserModel? get currentUser => _currentUserData;
  Business? get currentBusiness => _businessService.currentBusiness;
  String? get businessId => _businessService.businessId;

  void updateCurrentUser(Map<String, dynamic> updates) {
    _currentUserData = _currentUserData!.copyWithMap(updates);
    notifyListeners();
  }

  void updateState(AuthSessionState state) {
    _state = state;
    // notifyListeners();
  }

  Future<void> updateUserAndBusinessInfo({
    required UserModel updatedUser,
    required Business updatedBusiness,
  }) async {
    try {
      final userService = UserServices();
      final bizService = BusinessServices();

      // Update user in Firestore
      await userService.updateUserInfo(updatedUser.id, updatedUser.toJson());
      updateCurrentUser(updatedUser.toJson());
      UserStorage.updateUser(updatedUser.toJson());

      // Update business in Firestore
      await bizService.updateBusiness(
          updatedBusiness.id, updatedBusiness.toJson());
      await BusinessService.instance
          .updateBusiness(updatedBusiness, notify: true);

      // Optional: Notify
      ErrorNotificationService.showErrorToaster(
          message: "Successfully updated Information");
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: "Error Updating Information: $e",
        isDestructive: true,
      );
    }
  }

  Future<void> initializeSession() async {
    try {
      final user = await _loadUserData();
      if (user != null) {
        final business = await _loadBusinessData(user);
        if (business != null) {
          await _businessService.setBusiness(business);
        }
        await _persistSessionData(user, business);
      }
    } catch (e) {
      await _handleSessionError(e);
    }
  }

  Future<void> _persistSessionData(UserModel user, Business? business) async {
    await Future.wait<dynamic>([
      UserStorage.setUser(user.toJson()),
      if (business != null) BusinessStorage.setBusiness(business.toJson()),
    ]);
  }

  Future<UserModel?> _loadUserData() async {
    final userDoc =
        await _firestore.collection(Storage.users).doc(_currentUser?.uid).get();
    return userDoc.exists ? UserModel.fromJson(userDoc.data()!) : null;
  }

  Future<Business?> _loadBusinessData(UserModel user) async {
    if (user.businessID != null && user.businessID!.isNotEmpty) {
      final businessDoc = await _firestore
          .collection(Storage.businesses)
          .doc(user.businessID)
          .get();
      return businessDoc.exists ? Business.fromJson(businessDoc.data()!) : null;
    }
    return null;
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await _firestore
          .collection(Storage.users)
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInEmployee({
    required String identifier,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final parts = identifier.split('@');
      if (parts.length != 2) {
        throw AuthException('invalid-format', 'Use username@businessAbbrev');
      }

      final username = parts[0];
      final businessAbbrev = parts[1];

      final employeeData = await authService.signInEmployee(
        username,
        businessAbbrev,
        password,
      );

      debugPrint("Employee signed in: ${employeeData.toJson()['name']}");
    } catch (e) {
      ErrorNotificationService.showErrorToaster(
        message: (e as AuthException).operation,
        description: e.message,
        isDestructive: true,
      );
    }
  }

  Future<void> checkAuthStatus([AuthSessionState? state]) async {
    if (state != null) {
      _state = state;
    } else {
      await initializeSession();
    }
    notifyListeners();
  }

  Future<UserModel> _fetchUserModel(String uid) async {
    final doc = await _firestore.collection(Storage.users).doc(uid).get();
    return UserModel.fromJson(doc.data()!);
  }

  Future<Business?> _fetchBusinessModel(String businessId) async {
    final doc =
        await _firestore.collection(Storage.businesses).doc(businessId).get();
    logger.d('fetching business: ${doc.data()!}');
    return Business.fromJson(doc.data()!);
  }

  Future<void> signInAdminCustomer(
    String email,
    String password,
    BuildContext context,
  ) async {
    _isLoading = true;
    _state = AuthSessionState.loading();
    notifyListeners();

    try {
      final user = await authService.signInAdminCustomer(email, password);
      if (user == null) {
        throw AuthException('sign-in-failed', 'Invalid credentials');
      }

      logger.d(user.email);
      logger.w(_state.status.name);

      final userData = await _fetchUserModel(user.uid);
      if (userData.businessID == null) {
        throw AuthException('no-business', 'User has no associated business');
      }

      logger.d(userData.toJson());
      logger.w(_state.status.name);

      logger.d('Business ID: ${userData.businessID}');

      final businessData = await _fetchBusinessModel(userData.businessID!);
      if (businessData == null) {
        throw AuthException('no-business', 'Business not found');
      }

      logger.d(businessData.toJson());
      logger.w('sucessfully gotten business data ${_state.status.name}');

      await initializeSession();
      logger.i(_state.status.name);
      _state = AuthSessionState.authenticated(userData, businessData);
      // notifyListeners();
      _currentUser = user;
      _currentUserData = userData;
      await _businessService.setBusiness(businessData);
      logger.i(_state.status.name);

      ErrorNotificationService.showErrorToaster(
        message: "Successfully Logged In",
        description: 'Welcome back ${userData.name}',
      );
    } on FirebaseAuthException catch (e) {
      _state = AuthSessionState.error(
        e.message ?? 'Authentication failed',
        changeScreen: false,
      );
      ErrorNotificationService.showErrorToaster(
        message: 'Login Failed',
        description: _getAuthErrorMessage(e),
        isDestructive: true,
      );
    } on AuthException catch (e) {
      logger.e(e);
      _state = AuthSessionState.error(e.message, changeScreen: false);
      ErrorNotificationService.showErrorToaster(
        message: e.operation,
        description: e.message,
        isDestructive: true,
      );
    } catch (e) {
      logger.e(e.toString());
      _state = AuthSessionState.error('An unexpected error occurred');
      ErrorNotificationService.showErrorToaster(
        message: 'Error',
        description: 'Please try again later',
        isDestructive: true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email format';
      default:
        return e.message ?? 'Authentication failed';
    }
  }

  Future<void> signUpWithBusiness({
    required String email,
    required String password,
    required UserModel userModel,
    required Business businessModel,
  }) async {
    _isLoading = true;
    _state = AuthSessionState.loading();
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw AuthException('empty-fields', 'Please fill all required fields');
      }

      final user = await authService.registerUser(email, password);
      if (user == null) {
        throw AuthException('signup-failed', 'User creation failed');
      }

      final updatedUser = userModel.copyWith(id: user.uid);
      final updatedBusiness =
          businessModel.copyWith(ownerId: user.uid, updatedAt: DateTime.now());
      logger.d(
          'user info: ${updatedUser.toJson()}\nbiz info: ${updatedBusiness.toJson()}');
      await Future.wait<dynamic>([
        saveUserToFirestore(updatedUser),
        bizService.saveToFirebase(updatedBusiness),
      ]);
      logger.d("Successfully saved user and business to database");
      // await _persistSessionData(updatedUser, updatedBusiness);

      await initializeSession();

      _state = AuthSessionState.authenticated(updatedUser, updatedBusiness);

      _currentUser = user;
      _currentUserData = updatedUser;
      await _businessService.setBusiness(updatedBusiness);

      ErrorNotificationService.showErrorToaster(
        message: "Account Created",
        description: 'Welcome ${updatedUser.name}!',
      );
    } on FirebaseAuthException catch (e) {
      _state = AuthSessionState.error(
        _getAuthErrorMessage(e),
        changeScreen: false,
      );
      ErrorNotificationService.showErrorToaster(
        message: 'Signup Failed',
        description: _getAuthErrorMessage(e),
        isDestructive: true,
      );
    } on AuthException catch (e) {
      _state = AuthSessionState.error(
        e.message,
        changeScreen: false,
      );
      ErrorNotificationService.showErrorToaster(
        message: e.operation,
        description: e.message,
        isDestructive: true,
      );
    } catch (e) {
      _state = AuthSessionState.error('An unexpected error occurred');
      ErrorNotificationService.showErrorToaster(
        message: 'Error',
        description: 'Please try again later',
        isDestructive: true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleSessionError(dynamic e) async {
    await authService.clearSessionData();
    await _businessService.clearBusiness();
    _state = AuthSessionState.error(
        e is AuthException ? e.message : 'An unexpected error occurred');
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await authService.signOut();
      debugPrint('Logout firebase auth');
      await authService.clearSessionData();
      debugPrint('clear session data');
      await _businessService.clearBusiness();
      debugPrint('clear business data');
      if (context.mounted) {
        Provider.of<InventoryProvider>(context, listen: false).reset();
        debugPrint('reset inventory provider');
      }

      _state = AuthSessionState.unauthenticated();
      _currentUser = null;
      _currentUserData = null;

      ErrorNotificationService.showErrorToaster(
        message: "Logged Out",
        description: 'You have been successfully logged out',
      );
    } catch (e) {
      _state = AuthSessionState.error('Logout failed');
      ErrorNotificationService.showErrorToaster(
        message: 'Error',
        description: 'Failed to logout. Please try again.',
        isDestructive: true,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
