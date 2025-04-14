import 'package:flutter/cupertino.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';

class NavigationItem {
  final String id;
  final String label;
  final IconData icon;
  final List<UserRole> allowedRoles;
  final Widget screen;

  const NavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.allowedRoles,
    required this.screen,
  });
}