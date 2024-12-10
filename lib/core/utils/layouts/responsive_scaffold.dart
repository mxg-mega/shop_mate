import 'package:flutter/material.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.drawer,
    this.bottomNavigationBar,
    this.navigationRail,
  });

  final Widget? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? drawer;
  final BottomNavigationBar? bottomNavigationBar;
  final Widget? navigationRail;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Scaffold(
        appBar: AppBar(
          title: title,
          actions: actions,
        ),
        drawer: drawer,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      ),
      tablet: Scaffold(
        appBar: AppBar(
          title: title,
          actions: actions,
        ),
        body: Row(
          children: [
            if (navigationRail != null) navigationRail!, 
            Expanded(
              flex: navigationRail == null ? 1 : 7,
              child: body,
            ),
          ],
        ),
      ),
      desktop: Scaffold(
        body: Row(
          children: [
            if (navigationRail != null) navigationRail!,
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: title,
                  actions: actions,
                ),
                body: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
