import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/screens/login/components/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessInfoCard extends StatelessWidget {
  const BusinessInfoCard({
    super.key,
    required this.cardTitle,
  });
  final String cardTitle;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final authProv = Provider.of<AuthenticationProvider>(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 150.w,
      ),
      child: ShadCard(
        title: Text(
          cardTitle,
          style: theme.textTheme.h4,
        ),
        child: Column(
          children: [
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Business Name', context),
              placeholder: const Text('Business Name'),
              controller: authProv.bizNameController,
              keyboardType: TextInputType.name,
              validator: (value) => validate(
                  value,
                  'Please Enter Business Name',
                  0,
                  authProv.bizInfo,
                  {'name': value}),
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: const Text('Email'),
              placeholder: const Text('Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.length > 2 &&
                    !value.contains(
                        RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'))) {
                  return 'Enter a valid Email Address or leave Empty if the same as from user information';
                } else if (value.length < 2 || value == null) {
                  authProv.bizInfo.addAll({'email': null});
                  return null;
                } else {
                  authProv.bizInfo.addAll({'email': value});
                  return null;
                }
              },
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: const Text('Phone Number'),
              placeholder: const Text('Phone Number'),
              keyboardType: TextInputType.phone,
              controller: authProv.bizPhoneNumberController,
              validator: (value) {
                if (value.length > 2 &&
                    !value.contains(RegExp(r'^(\+234|0)([789]\d{9})$'))) {
                  return 'Please Enter valid Phone Number or Leave empty if the same as user information';
                } else if (value.length < 2 || value == null) {
                  authProv.bizInfo.addAll({'phoneNumber': null});
                } else {
                  authProv.bizInfo.addAll({'phoneNumber': value});
                }
                return null;
              },
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Address', context),
              placeholder: const Text('Address'),
              keyboardType: TextInputType.streetAddress,
              controller: authProv.addressController,
              validator: (v) => validate(
                v,
                'Please Enter business Address',
                15,
                authProv.bizInfo,
                {'address': v},
              ),
            ),
            const Perimeter(height: 3),
            ShadSelectFormField<BusinessCategories>(
              id: 'business_type',
              label: importantLabel('Select Business Type', context),
              onChanged: (c) => authProv.setCategory(c!),
              itemCount: BusinessCategories.values.length,
              initialValue: BusinessCategories.none,
              options: BusinessCategories.values
                  .map((role) => ShadOption(
                        value: role,
                        child: Text(role.name),
                      ))
                  .toList(),
              selectedOptionBuilder: (context, value) =>
                  value == BusinessCategories.none
                      ? const Text('Select Your Business Type')
                      : Text(value.name),
              validator: (value) => validate(
                value as BusinessCategories,
                'Please Choose your Business Category',
                BusinessCategories.none,
                authProv.bizInfo,
                {'type': value},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
