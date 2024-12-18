import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();
    final formKey = GlobalKey<ShadFormState>();

    final themeProv = Provider.of<ThemeProvider>(context);
    final authProv = Provider.of<AuthenticationProvider>(context);

    return ShadForm(
      key: formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: ShadInputFormField(
                placeholder: const Text('Email'),
                keyboardType: TextInputType.emailAddress,
                decoration: ShadDecoration(
                  shadows: ShadShadows.md,
                  color: themeProv.themeMode == ThemeMode.dark
                      ? Colors.white30
                      : null,
                ),
                controller: emailController,
                validator: (v) {
                  if (v.length < 2) {
                    return 'Please Input your Email Address';
                  }
                  if (!v.contains(
                      RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'))) {
                    return 'Please Input a valid Email Address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: ShadInputFormField(
                placeholder: const Text('Password'),
                keyboardType: TextInputType.visiblePassword,
                decoration: ShadDecoration(
                    shadows: ShadShadows.md,
                    color: themeProv.themeMode == ThemeMode.dark
                        ? Colors.white30
                        : null),
                controller: pwController,
                obscureText: true,
                validator: (v) {
                  if (v.length < 2) {
                    return 'Please Input your Password';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 320,
              ),
              child: ShadButton(
                child: Text('Sign In'),
                onPressed: () {
                  if (formKey.currentState!.saveAndValidate()) {
                    print('Validation Success');
                    authProv.signIn(
                        emailController.text, pwController.text, context);
                    if (authProv.isLoading) {
                      ErrorToaster(
                        context: context,
                        message: 'User Signing In...',
                      );
                    }
                  } else {
                    print("Validation Failed");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
