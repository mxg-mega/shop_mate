import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/data/models/auth_session_state.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/screens/home/home_screen.dart';
import 'package:shop_mate/screens/login/login_screen.dart';
import 'package:shop_mate/screens/splash_screen/error_screen.dart';
import 'package:shop_mate/screens/splash_screen/loading_screen.dart';
import 'package:shop_mate/screens/splash_screen/splash_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSplashComplete = false;

  void _handleSplashComplete() {
    if (mounted) {
      setState(() {
        _isSplashComplete = true;
      });
      context
          .read<AuthenticationProvider>()
          .checkAuthStatus(AuthSessionState.unauthenticated());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, _) {
      switch (authProvider.state.status) {
        case AuthStatus.initial:
          return SplashScreen(
            appName: "Shop Mate",
            tagline: "Smart Management Solutions",
            // primaryColor: const Color(0xFF4F46E5),
            primaryColor: theme.colorScheme.primary,
            // secondaryColor: const Color(0xFF10B981),
            secondaryColor: theme.colorScheme.secondary,
            duration: const Duration(seconds: 3),
            onComplete: _handleSplashComplete,
          );
        case AuthStatus.loading:
          return LoadingScreen(
            primaryColor: theme.colorScheme.primary,
            // secondaryColor: const Color(0xFF10B981),
            secondaryColor: theme.colorScheme.secondary,
          );
        case AuthStatus.authenticated:
          return HomeScreen();
        case AuthStatus.unauthenticated:
          return LoginScreen();
        case AuthStatus.error:
          if (authProvider.state.changeScreen == false) {
            authProvider.updateState(AuthSessionState.unauthenticated());
            return LoginScreen();
          }
          return ErrorScreen(
            primaryColor: theme.colorScheme.destructive,
            // secondaryColor: const Color(0xFF10B981),
            secondaryColor: theme.colorScheme.destructive,
            message: authProvider.state.errorMessage ?? 'Unkown-Error',
          );
      }
      return LoadingScreen();
    }
        // return StreamBuilder<AuthSessionState>(
        //   // stream: context.watch<AuthenticationProvider>().authSessionStream,
        //   stream: authProvider.authSessionStream,
        //   builder: (context, snapshot) {
        //     // var state = snapshot.data ?? AuthSessionState.initial();
        //     if (snapshot.hasError) {
        //       return ErrorScreen(
        //         message: snapshot.error.toString(),
        //       );
        //     }
        //     if (snapshot.hasData) {
        //       // if (state.status == AuthStatus.authenticated) {
        //       //   return HomeScreen();
        //       // } else if (state.status == AuthStatus.unauthenticated) {
        //       //   return LoginScreen();
        //       // }
        //       switch (snapshot.data!.status) {
        //         case AuthStatus.initial:
        //           return SplashScreen(
        //             appName: "Shop Mate",
        //             tagline: "Smart Management Solutions",
        //             // primaryColor: const Color(0xFF4F46E5),
        //             primaryColor: theme.colorScheme.primary,
        //             // secondaryColor: const Color(0xFF10B981),
        //             secondaryColor: theme.colorScheme.secondary,
        //             duration: const Duration(seconds: 3),
        //             onComplete: _handleSplashComplete,
        //           );
        //         case AuthStatus.loading:
        //           return LoadingScreen(
        //             primaryColor: theme.colorScheme.primary,
        //             // secondaryColor: const Color(0xFF10B981),
        //             secondaryColor: theme.colorScheme.secondary,
        //           );
        //         case AuthStatus.authenticated:
        //           return HomeScreen();
        //         case AuthStatus.unauthenticated:
        //           return LoginScreen();
        //         case AuthStatus.error:
        //           return ErrorScreen(
        //             primaryColor: theme.colorScheme.primary,
        //             // secondaryColor: const Color(0xFF10B981),
        //             secondaryColor: theme.colorScheme.secondary,
        //             message: snapshot.data!.errorMessage ?? 'Unkown-Error',
        //           );
        //       }
        //     }
        //     return LoadingScreen(
        //       primaryColor: theme.colorScheme.primary,
        //       // secondaryColor: const Color(0xFF10B981),
        //       secondaryColor: theme.colorScheme.secondary,
        //     );
        //     // if (!_isSplashComplete) {
        //     //   return SplashScreen(
        //     //     appName: "Shop Mate",
        //     //     tagline: "Smart Management Solutions",
        //     //     primaryColor: const Color(0xFF4F46E5),
        //     //     secondaryColor: const Color(0xFF10B981),
        //     //     duration: const Duration(seconds: 3),
        //     //     onComplete: _handleSplashComplete,
        //     //   );
        //     // }
        //     // WidgetsBinding.instance.addPostFrameCallback((_) {
        //     //   if (mounted) {
        //     //     if (state.status == AuthStatus.authenticated) {
        //     //       Navigator.pushReplacement(
        //     //         context,
        //     //         MaterialPageRoute(builder: (_) => HomeScreen()),
        //     //       );
        //     //     } else if (state.status == AuthStatus.unauthenticated) {
        //     //       Navigator.pushReplacement(
        //     //         context,
        //     //         MaterialPageRoute(builder: (_) => LoginScreen()),
        //     //       );
        //     //     }
        //     //   }
        //     // });
        //     // return LoadingScreen();
        //   },
        // );
        );
  }
}
