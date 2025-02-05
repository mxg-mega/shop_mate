import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/screens/login/components/business_info_card.dart';
import 'package:shop_mate/screens/login/components/user_info_card.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
    final authProv = Provider.of<AuthenticationProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: ShadForm(
        key: formKey,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250.w),
          child: Column(
            children: [
              const UserInfoCard(
                cardTitle: 'User Information',
              ),
              const Perimeter(height: 3),
              const BusinessInfoCard(
                cardTitle: 'Business Information',
              ),
              const Perimeter(height: 3),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 320,
                ),
                child: ShadButton(
                  child: const Text('Sign Up'),
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {
                      print('Validation Success');
                      print('User: ${authProv.userInfo}');
                      print('Business : ${authProv.bizInfo}');
                      try {
                        print('Signing up .......');
                        await authProv.signUp(
                          context: context,
                          email: authProv.emailController.text,
                          password: authProv.pwController.text,
                          name: authProv.nameController.text,
                          phoneNumber: authProv.phoneNumberController.text,
                          role: authProv.selectedRole,
                          businessAddress: authProv.addressController.text,
                          businessName: authProv.bizNameController.text,
                          businessPhone: authProv.bizPhoneNumberController.text,
                          businessEmail: authProv.bizEmailController.text,
                          businessCategory: authProv.selectedBusinessCategory,
                        );
                      } catch (e) {
                        print('Error Signing Up.......!');
                        ErrorNotificationService.showErrorToaster(
                          message: 'Error Creating User',
                          isDestructive: true,
                        );
                      }
                    } else {
                      print("Validation Failed");
                      ErrorNotificationService.showErrorToaster(
                          message: 'Validation Failed',
                          isDestructive: true,);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
