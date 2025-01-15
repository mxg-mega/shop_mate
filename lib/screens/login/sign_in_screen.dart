import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/screens/login/components/my_input_form_field.dart';

import '../../providers/session_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final pwController = TextEditingController();
    final formKey = GlobalKey<ShadFormState>();

    final themeProv = Provider.of<ThemeProvider>(context);
    final authProv = Provider.of<AuthenticationProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

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
              child: MyInputFormField(
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (v) {
                  if (v.length < 2) {
                    return 'Please Input your Email Address';
                  }
                  if (v.contains(RegExp(r'^[\w-\.]+@[a-zA-Z]+$')) ||
                      v.contains(
                          RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'))) {
                    return null;
                  } else {
                    return 'Please Input a valid Email Address or username';
                  }
                },
              ),
            ),
            const SizedBox(height: 2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: MyInputFormField(
                placeholder: 'Password',
                keyboardType: TextInputType.visiblePassword,
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
            const SizedBox(
              height: 5,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 320,
              ),
              child: ShadButton(
                child: const Text('Sign In'),
                onPressed: () async {
                  if (formKey.currentState!.saveAndValidate()) {
                    print('Validation Success');
                    // check if email

                    // check if it is a username
                    // if it is a username then check through the 'business'
                    // collections and then check through employees and compare username,
                    // get the employee info then compare password

                    try {
                      if (emailController.text.contains('@') &&
                          !emailController.text.contains('.com')) {
                        print("You are an Employee");
                        await authProv.signInEmployee(
                            emailController.text, pwController.text, context);
                      } else {
                        print("You are an Admin/Customer");
                        await authProv.signInAdminCustomer(
                            emailController.text, pwController.text, context, sessionProvider);
                      }
                    } catch (e) {
                      print(e);
                    }
                    if (authProv.isLoading && context.mounted) {
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
