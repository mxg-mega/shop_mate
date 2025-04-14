import "package:flutter/material.dart";
import "package:shop_mate/core/utils/constants.dart";

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileWidth;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileWidth &&
      MediaQuery.of(context).size.width <= desktopWidth;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= desktopWidth) {
        return desktop ?? tablet ?? mobile;
      } else if (constraints.maxWidth >= mobileWidth) {
        return tablet ?? mobile;
      } else {
        return mobile;
      }
    });
  }
}
