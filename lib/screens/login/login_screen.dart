import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/screens/login/components/sign_in_screen.dart';
import 'package:shop_mate/screens/login/components/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProv = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20 * (size.height / 100)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 450, minHeight: 300),
            child: ShadCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                  ),
                  Perimeter(
                    height: 8,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: showSignIn ? SignInScreen() : SignUpScreen(),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showSignIn = !showSignIn;
                      });
                    },
                    child: showSignIn
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Don't have an account? "),
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
                              Text("Already have an account? "),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
