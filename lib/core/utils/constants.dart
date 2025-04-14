import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:logger/logger.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/features/responsive_design/layouts/responsive_layout.dart';

const mobileWidth = 650;
const desktopWidth = 1100;
final logger = Logger();

// ignore: camel_case_types
class kImages {
  static const String _imagePath = 'assets/images';
  static const String defaultProfilePic =
      '$_imagePath/default_profile_picture.png';
}

class Storage {
  static const String users = 'Users';
  static const String businesses = 'Businesses';
  static const String inventory = 'Inventory';
  static const String employees = 'Employees';
  static const String sales = 'Sales';
  static const String expenses = 'Expenses';
  static const String budget = 'Budget';
  static const String products = 'Products';
}

List<Map<String, dynamic>> modules = [
  {
    'name': 'dashboard',
    'icon': Bootstrap.house,
    'lucide': LucideIcons.house,
    'label': 'Dashboard'
  },
  {
    'name': 'inventory',
    'icon': Bootstrap.box,
    'lucide': LucideIcons.box,
    'label': 'Inventory'
  },
  {
    'name': 'credit_management',
    'icon': Bootstrap.credit_card,
    'another': Icons.credit_card_outlined,
    'lucide': LucideIcons.creditCard,
    'label': 'Credit'
  }
];

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Drawer(
      shadowColor: Colors.grey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerHeader(
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 40.w,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0.w, horizontal: 12.0.w),
            child: ListTile(
              leading: const Icon(
                Icons.home_outlined,
                size: 25,
              ),
              title: Text("D A S H B O A R D", style: theme.textTheme.list),
              onTap: () {
                if (ResponsiveLayout.isMobile(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0.w, horizontal: 12.0.w),
            child: ListTile(
              leading: const Icon(
                Icons.home_outlined,
                size: 25,
              ),
              title: Text("I N V E N T O R Y", style: theme.textTheme.list),
              onTap: () {
                if (ResponsiveLayout.isMobile(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
