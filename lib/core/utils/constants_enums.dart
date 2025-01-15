import 'package:flutter/material.dart';

enum SubscriptionTiers{
  free,
  basic,
  standard,
  premium,
}

enum Features{
  dashboard,
  inventory,
  sales,
  analytics,
  creditManagement,
  zakatTracker,
  settings,
}

/// Roles specifically when signing up
enum RegistrationUserRole {
  admin,
  customer,
}

/// Roles for when the user is an admin
/// for cases such as creating an employee account
/// or even updating/upgrading an employee account
/// TODO: update the use cases of User role during registeration
enum UserRole {
  none,
  admin,
  staff,
  manager,
  employee,
  accountant,
  customer,
}

enum BusinessCategories {
  none,
  retail,
  pharmacy,
  provision,
  electronics,
  supplies,
  other,
}

class Perimeter extends StatelessWidget {
  const Perimeter({this.height = 0, this.width = 0, super.key});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: height * (size.height / 100),
      width: width * (size.width / 100),
    );
  }
}
