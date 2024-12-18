import 'package:flutter/material.dart';

enum SubscriptionTypes{
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

enum RoleTypes {
  none,
  admin,
  staff,
  customer,
}

enum BusinessCategories {
  none,
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
