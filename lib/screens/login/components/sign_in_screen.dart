import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/providers/theme_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController? _emailController;
    TextEditingController? _pwController;
    final formKey = GlobalKey<ShadFormState>();

    var themeProv = Provider.of<ThemeProvider>(context);
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
                  shadows: ShadShadows.regular,
                  color: themeProv.themeMode == ThemeMode.dark
                      ? Colors.white30
                      : null,
                ),
                controller: _emailController,
                validator: (v) {
                  if (v.length < 2) {
                    return 'Please Input your Email Address';
                  }
                  if (!v.contains(RegExp(
                      r'^[A-Za-z0-9._%+-]@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$'))) {
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
                controller: _pwController,
                obscureText: true,
                validator: (v) {
                  if (v.length < 8) {
                    return 'Please Input at least 8 Characters Long';
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
