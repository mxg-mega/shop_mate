import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/providers/navigation_provider.dart';
import 'package:shop_mate/screens/home/components/my_sidebar.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final UserRole userRole;

  const ResponsiveScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    required this.userRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      drawer: Drawer(
        child: ResponsiveNavigation(userRole: userRole),
      ),
      body: body,
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        leading: _buildMenuButton(context),
      ),
      body: Row(
        children: [
          ResponsiveNavigation(userRole: userRole),
          Expanded(child: body,),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        leading: _buildMenuButton(context),
      ),
      body: Row(
        children: [
          ResponsiveNavigation(userRole: userRole),
          Expanded(child: body,),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Provider.of<NavigationProvider>(context, listen: false).toggleSidebar();
      },
    );
  }
}
