import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';

const mobileWidth = 650;
const desktopWidth = 1100;

// ignore: camel_case_types
class kImages {
  static const String _imagePath = 'assets/images';
  static const String defaultProfilePic =
      '$_imagePath/default_profile_picture.png';
}

class Storage {
  static const String users = 'users';
  static const String businesses = 'businesses';
  static const String inventory = 'inventory';
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Drawer(
      elevation: ResponsiveLayout.isTablet(context) ? 0.0 : 10,
      clipBehavior: Clip.antiAlias,
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
