import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // bool IsLoggedIn() {
  //   if (auth.)
  //   return _isLoggedIn;
  // }
}
