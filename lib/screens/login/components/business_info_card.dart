import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/providers/auth_provider.dart';
import 'package:shop_mate/screens/login/components/constants.dart';

class BusinessInfoCard extends StatelessWidget {
  BusinessInfoCard({
    super.key,
    required this.cardTitle,
    required this.businessInfoControllers,
  });
  final String cardTitle;
  List<TextEditingController> businessInfoControllers;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    ShadPopoverController businessTypeController = ShadPopoverController();
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    final _authProv = Provider.of<AuthProvider>(context);

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
              label: importantLabel('Business Name', context),
              placeholder: const Text('Business Name'),
              controller: nameController,
              keyboardType: TextInputType.name,
              validator: (value) =>
                  validate(value, 'Please Enter Business Name', 0),
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: Text('Email'),
              placeholder: Text('Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty ||
                    value.contains(
                        RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'))) {
                  return null;
                } else {
                  return 'Enter a valid email or leave empty if same as user email';
                }
              },
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: Text('Phone Number'),
              placeholder: Text('Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value.length < 10 && value.contains(RegExp(r'[0-9]'))) {
                  return 'Please Enter valid Phone Number';
                }
                return null;
              },
            ),
            const Perimeter(height: 3),
            ShadInputFormField(
              label: importantLabel('Address', context),
              placeholder: Text('Address'),
              keyboardType: TextInputType.streetAddress,
              validator: (v) =>
                  validate(v, 'Please Enter business Address', 15),
            ),
            const Perimeter(height: 3),
            ShadSelectFormField<BusinessCategories>(
              id: 'business_type',
              label: importantLabel('Select Business Type', context),
              controller: businessTypeController,
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
                  BusinessCategories.none),
            ),
          ],
        ),
      ),
    );
  }
}
