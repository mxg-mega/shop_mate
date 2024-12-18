import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/screens/home/home_screen.dart';
import 'package:shop_mate/screens/login/login_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<SessionProvider>(context);

    return StreamBuilder<User?>(
        stream: authProv.auth.authStateChanges(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        });
  }
}
