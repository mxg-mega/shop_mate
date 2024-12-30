import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/screens/login/sign_in_screen.dart';
import 'package:shop_mate/screens/login/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final authProv = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 150.h, horizontal: 30.w),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 450.w, minHeight: 300.h),
            child: ShadCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                  ),
                  const Perimeter(
                    height: 8,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Consumer<AuthenticationProvider>(
                      builder: (context, authProvider, child) {
                        if (!authProvider.showSignIn) {
                          return const SignUpScreen();
                        }
                        return const SignInScreen();
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthenticationProvider>().signInToggle();
                    },
                    child: authProv.showSignIn
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Don't have an account? "),
                              Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: themeProv.isDarkTheme
                                        ? Colors.amber
                                        : Colors.blue),
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Already have an account? "),
                              Text(
                                "Sign In",
                                style: TextStyle(
                                    color: themeProv.isDarkTheme
                                        ? Colors.amber
                                        : Colors.blue),
                              )
                            ],
                          ),
                  ),
                  authProv.isLoading
                      ? SizedBox(
                          width: 70.w,
                          child: const ShadProgress(
                            minHeight: 4,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
