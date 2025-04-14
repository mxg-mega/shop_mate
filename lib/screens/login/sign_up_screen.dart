import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/error/my_exceptions.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/data/models/auth_session_state.dart';

import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/data/models/users/user_model.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/screens/login/components/business_info_card.dart';
import 'package:shop_mate/screens/login/components/user_info_card.dart';
import 'package:shop_mate/screens/login/utils/login_controller.dart';
import 'package:shop_mate/services/auth_services.dart';
import 'package:shop_mate/services/business_services.dart';
import 'package:shop_mate/services/user_services.dart';

class SignUpPage extends StatefulWidget {
  final LoginController controller;
  final VoidCallback onSwitch;

  const SignUpPage(
      {super.key, required this.controller, required this.onSwitch});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formkey = GlobalKey<ShadFormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ShadForm(
        key: _formkey,
        autovalidateMode: ShadAutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            UserInfoSection(
              controller: widget.controller,
              cardTitle: 'User Information',
            ),
            const Perimeter(height: 3),
            BusinessInfoSection(
              controller: widget.controller,
              cardTitle: 'Business Information',
            ),
            const Perimeter(height: 3),
            _buildSubmitButton(context),
            const Perimeter(height: 3),
            ShadButton.ghost(
              onPressed: widget.onSwitch,
              child: const Text('Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ShadButton(
      enabled: true,
      icon: Provider.of<AuthenticationProvider>(context).isLoading
          ? const CircularProgressIndicator()
          : null,
      onPressed: () {
        debugPrint('pressed the sign up button');
        if (_formkey.currentState!.validate()) {
          debugPrint('validated');
          handleSignUp(context);
        }
      },
      child: const Text('Create Account'),
    );
    // return Consumer<AuthenticationProvider>(
    //   builder: (context, auth, _) {
    //     return
    //   },
    // );
  }

  Future<void> handleSignUp(BuildContext context) async {
    final auth = Provider.of<AuthenticationProvider>(context, listen: false);

    try {
      debugPrint('in the try catch');
      final email = widget.controller.emailController.text;
      final password = widget.controller.pwController.text;

      debugPrint('before usermodel creation');

      final userModel = MyAuthService.createUserModel(
        id: 'i',
        email: email,
        password: password,
        name: widget.controller.nameController.text,
        role: widget.controller.role,
        phoneNumber: widget.controller.phoneNumberController.text,
        businessID: '',
        profilePicture: '',
      );
      debugPrint('after usermodel creation');

      final businessModel = BusinessServices.createBusiness(
        name: widget.controller.bizNameController.text,
        email: widget.controller.bizEmailController.text,
        phone: widget.controller.bizPhoneNumberController.text,
        address: widget.controller.addressController.text,
        businessType: widget.controller.businessCategory,
        ownerID: '',
      );

      await auth.signUpWithBusiness(
        email: email,
        password: password,
        userModel: userModel,
        businessModel: businessModel,
      );
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

// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final formKey = GlobalKey<ShadFormState>();
//     final authProv = Provider.of<AuthenticationProvider>(context);

//     return ShadForm(
//       key: formKey,
//       child: ConstrainedBox(
//         constraints: BoxConstraints(maxWidth: 250.w),
//         child: Column(
//           children: [
//             const UserInfoCard(
//               cardTitle: 'User Information',
//             ),
//             const Perimeter(height: 3),
//             const BusinessInfoCard(
//               cardTitle: 'Business Information',
//             ),
//             const Perimeter(height: 3),
//             ConstrainedBox(
//               constraints: const BoxConstraints(
//                 minWidth: 320,
//               ),
//               child: ShadButton(
//                 child: const Text('Sign Up'),
//                 onPressed: () async {
//                   if (formKey.currentState!.saveAndValidate()) {
//                     print('Validation Success');
//                     print('User: ${authProv.userInfo}');
//                     print('Business : ${authProv.bizInfo}');
//                     try {
//                       print('Signing up .......');
//                       await authProv.signUp(
//                         email: authProv.emailController.text,
//                         password: authProv.pwController.text,
//                       );
//                     } catch (e) {
//                       print('Error Signing Up.......!');
//                       ErrorNotificationService.showErrorToaster(
//                         message: 'Error Creating User',
//                         isDestructive: true,
//                       );
//                     }
//                   } else {
//                     print("Validation Failed");
//                     ErrorNotificationService.showErrorToaster(
//                       message: 'Validation Failed',
//                       isDestructive: true,
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
