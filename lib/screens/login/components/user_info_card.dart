import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/screens/login/components/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.cardTitle,
  });
  final String cardTitle;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);

    bool obsecure = true;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 150.w),
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
              placeholder: const Text('Full Name'),
              keyboardType: TextInputType.name,
              controller: authProvider.nameController,
              validator: (value) => validate(
                value,
                'Please Enter Your Full name',
                3,
                authProvider.userInfo,
                {'name': value},
              ),
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Email', context),
              placeholder: const Text('Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.length < 2 ||
                    !value.contains(
                        RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'))) {
                  return 'Enter a valid Email Address';
                } else {
                  authProvider.userInfo.addAll({'email': value});
                  return null;
                }
              },
              controller: authProvider.emailController,
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Phone Number', context),
              controller: authProvider.phoneNumberController,
              placeholder: const Text('Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v.isEmpty ||
                    !v.contains(RegExp(r'^(\+234|0)([789]\d{9})$'))) {
                  return 'Please Provide a Phone number';
                }
                authProvider.userInfo.addAll({'phoneNumber': v});
                return null;
              },
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Password', context),
              placeholder: const Text('Password'),
              keyboardType: TextInputType.visiblePassword,
              obscureText: obsecure,
              validator: (value) {
                if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
              controller: authProvider.pwController,
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Confirm Password', context),
              placeholder: const Text('Confirm Password'),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (p) {
                if (p != authProvider.pwController.text) {
                  return 'Please confirm the password correctly';
                }
                return null;
              },
            ),
            const Perimeter(height: 3),
            ShadSelectFormField<UserRole>(
              onChanged: (r) => authProvider.setRole(r!),
              label: importantLabel('User Role', context),
              id: 'user_role',
              itemCount: UserRole.values.length,
              initialValue: UserRole.none,
              options: UserRole.values
                  .map(
                      (role) => ShadOption(value: role, child: Text(role.name)))
                  .toList(),
              selectedOptionBuilder: (context, value) => value == UserRole.none
                  ? const Text('Select Your Role')
                  : Text(value.name),
              validator: (value) => validate(
                value as UserRole,
                'Please Choose Your Role',
                UserRole.none,
                authProvider.userInfo,
                {'role': value},
              ),
            )
          ],
        ),
      ),
    );
  }
}
