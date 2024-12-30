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
    final sessionProvider = Provider.of<SessionProvider>(context);

    return StreamBuilder<User?>(
      stream: sessionProvider.firebaseAuthStream,
      builder: (context, authSnapshot) {
        if (authSnapshot.hasData) {
          // Firebase Authenticated User (Admin/Customer)
          return const HomeScreen();
        } else {
          // Check for Custom Employee Session
          return StreamBuilder<bool>(
            stream: sessionProvider.customSessionStream,
            builder: (context, customSessionSnapshot) {
              if (customSessionSnapshot.hasData &&
                  customSessionSnapshot.data == true) {
                return const HomeScreen(); // Custom Employee Session Active
              } else {
                return const LoginScreen(); // Not Logged In
              }
            },
          );
        }
      },
    );
  }
}
