import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/screens/login/components/constants.dart';

class UserInfoCard extends StatelessWidget {
  UserInfoCard({
    super.key,
    required this.cardTitle,
    required this.userInfoControllers,
  });
  final String cardTitle;
  List<TextEditingController> userInfoControllers;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    TextEditingController? pwController = TextEditingController();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 350),
      child: ShadCard(
        title: Text(
          cardTitle,
          style: theme.textTheme.h4,
        ),
        child: Column(
          children: [
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Full name', context),
              placeholder: Text('Full Name'),
              keyboardType: TextInputType.name,
              validator: (value) =>
                  validate(value, 'Please Enter Your Full name', 3),
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Email', context),
              placeholder: Text('Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.length < 10 &&
                    value.contains(RegExp(r'[0-9].[0-9]'))) {
                  return 'Please Enter valid Phone Number';
                }
                return null;
              },
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Phone Number', context),
              placeholder: Text('Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  validate(v, 'Please Provide a Phone number', 11),
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Password', context),
              placeholder: Text('Password'),
              keyboardType: TextInputType.visiblePassword,
              controller: pwController,
              obscureText: true,
              validator: (v) =>
                  validate(v, 'password must be at least 8 characters', 8),
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Confirm Password', context),
              placeholder: Text('Confirm Password'),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (p) {
                if (p != pwController.text) {
                  return 'Please confirm the password correctly';
                }
                return null;
              },
            ),
            const Perimeter(height: 3),
            ShadSelectFormField<RoleTypes>(
              label: importantLabel('User Role', context),
              id: 'user_role',
              itemCount: RoleTypes.values.length,
              initialValue: RoleTypes.none,
              options: RoleTypes.values
                  .map(
                      (role) => ShadOption(value: role, child: Text(role.name)))
                  .toList(),
              selectedOptionBuilder: (context, value) => value == RoleTypes.none
                  ? const Text('Select Your Role')
                  : Text(value.name),
              validator: (value) => validate(value as RoleTypes,
                  'Please Choose Your Role', RoleTypes.none),
            )
          ],
        ),
      ),
    );
  }
}
