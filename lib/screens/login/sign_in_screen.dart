import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/error/my_exceptions.dart';
import 'package:shop_mate/core/utils/helpers.dart';
import 'package:shop_mate/data/models/auth_session_state.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/screens/login/components/constants.dart'
    as EmailValidator;
import 'package:shop_mate/screens/login/components/my_input_form_field.dart';
import 'package:shop_mate/screens/login/utils/login_controller.dart';

class SignInPage extends StatefulWidget {
  final LoginController controller;
  final VoidCallback onSwitch;

  const SignInPage(
      {super.key, required this.controller, required this.onSwitch});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<ShadFormState>();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width(context, 0.02)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width(context, 0.7)),
          child: ShadCard(
            padding: const EdgeInsets.all(8.0),
            child: ShadForm(
              key: _formKey,
              autovalidateMode: ShadAutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShadInputFormField(
                    controller: widget.controller.emailController,
                    leading: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(LucideIcons.mail),
                    ),
                    label: const Text('Email'),
                    placeholder: Text('user@example.com'),
                    keyboardType: TextInputType.emailAddress,
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
                  ShadInputFormField(
                    trailing: ShadButton(
                      width: 24,
                      height: 24,
                      padding: EdgeInsets.zero,
                      decoration: const ShadDecoration(
                        secondaryBorder: ShadBorder.none,
                        secondaryFocusedBorder: ShadBorder.none,
                      ),
                      icon:
                          Icon(obscure ? LucideIcons.eyeOff : LucideIcons.eye),
                      onPressed: () {
                        setState(() => obscure = !obscure);
                      },
                    ),
                    leading: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(LucideIcons.lock),
                    ),
                    controller: widget.controller.pwController,
                    label: const Text('Password'),
                    placeholder: Text('Password'),
                    obscureText: obscure,
                    validator: (value) => value.length >= 8
                        ? null
                        : 'Password must be at least 8 characters',
                  ),
                  // ShadButton(
                  //   onPressed: () => _handleSignIn(context),
                  //   child: const Text('Sign In'),
                  // ),
                  Consumer<AuthenticationProvider>(
                    builder: (context, auth, _) {
                      return ShadButton(
                        leading: auth.isLoading
                            ? const CircularProgressIndicator()
                            : null,
                        onPressed: _submitForm,
                        child: const Text('Sign In'),
                      );
                    },
                  ),
                  ShadButton.ghost(
                    onPressed: widget.onSwitch,
                    child: const Text(
                      'Don\'t have an Account ?! Sign Up here',
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _handleSignIn(context);
      // context.read<AuthenticationProvider>().signIn(
      //       _emailController.text,
      //       _passwordController.text,
      //     );
    }
  }

  Future<void> _handleSignIn(BuildContext context) async {
    final auth = context.read<AuthenticationProvider>();
    try {
      if (widget.controller.emailController.text.contains('@') &&
          !widget.controller.emailController.text.contains('.com')) {
        await auth.signInEmployee(
          identifier: widget.controller.emailController.text,
          password: widget.controller.pwController.text,
          context: context,
        );
      } else {
        await auth.signInAdminCustomer(
          widget.controller.emailController.text,
          widget.controller.pwController.text,
          context,
        );
        // auth.checkAuthStatus(AuthSessionState.authenticated(auth., business));
      }
    } on AuthException catch (e) {
      ShadToast.destructive(
        description: Text(e.message),
      );
    } catch (e) {
      ShadToast.destructive(
        description: const Text('An unexpected error occurred'),
      );
    }
  }
}
// class SignInScreen extends StatelessWidget {
//   const SignInScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final pwController = TextEditingController();
//     final formKey = GlobalKey<ShadFormState>();
//     final authProv = Provider.of<AuthenticationProvider>(context);

//     return ShadForm(
//       key: formKey,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 320),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 320),
//               child: MyInputFormField(
//                 placeholder: 'Email',
//                 keyboardType: TextInputType.emailAddress,
//                 controller: emailController,
//                 validator: (v) {
//                   if (v.length < 2) {
//                     return 'Please Input your Email Address';
//                   }
//                   if (v.contains(RegExp(r'^[\w-\.]+@[a-zA-Z]+$')) ||
//                       v.contains(
//                           RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'))) {
//                     return null;
//                   } else {
//                     return 'Please Input a valid Email Address or username';
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 2),
//             ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 320),
//               child: MyInputFormField(
//                 placeholder: 'Password',
//                 keyboardType: TextInputType.visiblePassword,
//                 controller: pwController,
//                 obscureText: true,
//                 validator: (v) {
//                   if (v.length < 2) {
//                     return 'Please Input your Password';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             ConstrainedBox(
//               constraints: const BoxConstraints(
//                 minWidth: 320,
//               ),
//               child: ShadButton(
//                 child: const Text('Sign In'),
//                 onPressed: () async {
//                   if (formKey.currentState!.saveAndValidate()) {
//                     debugPrint('Validation Success');
//                     // check if email

//                     // check if it is a username
//                     // if it is a username then check through the 'business'
//                     // collections and then check through employees and compare username,
//                     // get the employee info then compare password

//                     try {
//                       if (emailController.text.contains('@') &&
//                           !emailController.text.contains('.com')) {
//                         debugPrint("You are an Employee");
//                         await authProv.signInEmployee(
//                           identifier: emailController.text,
//                           password: pwController.text,
//                           context: context,
//                         );
//                       } else {
//                         debugPrint("You are an Admin/Customer");
//                         await authProv.signInAdminCustomer(
//                           emailController.text,
//                           pwController.text,
//                           context,
//                         );
//                       }
//                     } catch (e) {
//                       debugPrint(e.toString());
//                       ErrorNotificationService.showErrorToaster(
//                         message: 'Signing In failed',
//                         isDestructive: true,
//                       );
//                     }

//                   } else {
//                     debugPrint("Validation Failed");
//                   }
//                 },
//               ),
//             ),
//             if (authProv.state is AuthError)
//               Text(
//                 (authProv.state as AuthError).message,
//                 style: TextStyle(color: Colors.red),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
