import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/components/theme_toggle.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';
import 'package:shop_mate/core/utils/layouts/responsive_scaffold.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/sidebar_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/screens/home/components/my_card.dart';
import 'package:shop_mate/screens/home/components/my_sidebar.dart';
import 'package:shop_mate/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = MyAuthService();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sessionProv = Provider.of<SessionProvider>(context);
    final sidebarProv = Provider.of<SidebarProvider>(context);

    return ResponsiveScaffold(
      title: const Text(
        "N A I J A B I Z",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      drawer: const MyDrawer(),
      navigationRail: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: sidebarProv.sidebarOpen ? 250 : 60,
        child: MySidebar(),
      ),
      actions: [
        const ThemeToggle(),
        const Perimeter(width: 2),
        GestureDetector(
          child: const Icon(
            Icons.logout,
          ),
          onTap: () {
            sessionProv.auth.signOut();
            authService.signOut();
          },
        ),
        const Perimeter(
          width: 2,
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.5.w),
            child: Text(
              'Welcome to Your DashBoard ${MyAuthService().getCurrentUser()?.email.toString()}',
              style: TextStyle(
                fontSize: theme.textTheme.h1.fontSize,
                fontFamily: theme.textTheme.family,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.0.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveLayout.isMobile(context) ? 1 : 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 7,
              mainAxisExtent: 200,
            ),
            shrinkWrap: true,
            children: [
              MyCard(
                title: Text("Overall Products", style: theme.textTheme.h3),
              ),
              MyCard(
                title: Text("Daily Profits", style: theme.textTheme.h3),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: theme.colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "HOME",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: "INVENTORY"),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "CREDIT",
          ),
        ],
      ),
    );
  }

  NavigationRail myNavigationRail(BuildContext context) {
    return NavigationRail(
      indicatorShape: ContinuousRectangleBorder(
        side: BorderSide(
            width: 100, color: ShadTheme.of(context).colorScheme.selection),
      ),
      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          label: Text(
            'D A S H B O A R D',
            style: ShadTheme.of(context).textTheme.list,
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.currency_exchange),
          label: Text(
            'S A L E S',
            style: ShadTheme.of(context).textTheme.list,
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          label: Text(
            'I N V E N T O R Y',
            style: ShadTheme.of(context).textTheme.list,
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_month_outlined),
          label: Text(
            'ZAKAT TRACKER',
            style: ShadTheme.of(context).textTheme.list,
          ),
        ),
      ],
      onDestinationSelected: (index) {
        Provider.of<SidebarProvider>(context, listen: false)
            .setSelectedIndex(index);
      },
      selectedIndex: 0,
    );
  }
}
