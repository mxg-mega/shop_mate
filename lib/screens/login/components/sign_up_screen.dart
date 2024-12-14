import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/screens/login/components/business_info_card.dart';
import 'package:shop_mate/screens/login/components/user_info_card.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
    List<TextEditingController> userInfoControllers = [];
    List<TextEditingController> businessInfoControllers = [];

    return ShadForm(
      key: formKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 450),
        child: Column(
          children: [
            UserInfoCard(
              cardTitle: 'User Information',
              userInfoControllers: userInfoControllers,
            ),
            const Perimeter(height: 3),
            BusinessInfoCard(
              cardTitle: 'Business Information',
              businessInfoControllers: businessInfoControllers,
            ),
            const Perimeter(height: 3),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 320,
              ),
              child: ShadButton(
                child: Text('Sign Up'),
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
