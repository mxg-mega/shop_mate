import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic> userInfoControllers = {};
  Map<String, dynamic> businessInfoControllers = {};

  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Simulate network request
      await Future.delayed(Duration(seconds: 2));
      // Handle authentication logic
      print("User signed in with $email");
    } catch (e) {
      print("Error signing in: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(Map<String, String> userInfo) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Simulate network request
      await Future.delayed(Duration(seconds: 2));
      // Handle registration logic
      print("User signed up: ${userInfo.toString()}");
    } catch (e) {
      print("Error signing up: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
