import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

const mobileWidth = 650;
const desktopWidth = 1100;

// ignore: camel_case_types
class kImages {
  static const String _imagePath = 'assets/images';
  static const String defaultProfilePic =
      '$_imagePath/default_profile_picture.png';
}

Drawer myDrawer(BuildContext context) {
  final theme = ShadTheme.of(context);
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          leading: Icon(
            Icons.home,
            size: 30,
          ),
          title: Text("Home", style: theme.textTheme.lead),
        ),
      ],
    ),
  );
}
