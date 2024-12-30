import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';
import 'package:shop_mate/providers/sidebar_provider.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    required this.drawer,
    this.bottomNavigationBar,
    required this.navigationRail,
  });

  final Widget? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget drawer;
  final BottomNavigationBar? bottomNavigationBar;
  final Widget navigationRail;

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
          leading: Padding(
            padding: EdgeInsets.only(left: 7.0.w),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Provider.of<SidebarProvider>(context, listen: false)
                    .toggleSideBar();
              },
            ),
          ),
        ),
        body: Row(
          children: [
            navigationRail,
            Expanded(
              flex: 2,
              child: body,
            ),
          ],
        ),
      ),
      desktop: Scaffold(
        appBar: AppBar(
          title: title,
          actions: actions,
          leadingWidth: 20.w,
          automaticallyImplyLeading: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Provider.of<SidebarProvider>(context, listen: false)
                    .toggleSideBar();
              },
            ),
          ),
        ),
        body: Row(
          children: [
            navigationRail,
            Expanded(
              flex: 2,
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
