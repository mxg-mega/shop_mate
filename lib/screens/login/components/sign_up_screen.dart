import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
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
          constraints: BoxConstraints(maxWidth: 450.w),
          child: Column(
            children: [
              UserInfoCard(
                cardTitle: 'User Information',
              ),
              const Perimeter(height: 3),
              BusinessInfoCard(
                cardTitle: 'Business Information',
              ),
              const Perimeter(height: 3),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 320.w,
                ),
                child: ShadButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                    if (formKey.currentState!.saveAndValidate()) {
                      print('Validation Success');
                      print('User: ${authProv.userInfo}');
                      print('Business : ${authProv.bizInfo}');
                      authProv.signUp(authProv.userInfo, authProv.bizInfo);
                    } else {
                      print("Validation Failed");
                      ErrorToaster(
                          context: context,
                          message: 'Validation Failed',
                          isDestructive: true);
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
