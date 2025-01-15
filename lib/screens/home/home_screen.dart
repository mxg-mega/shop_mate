import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/components/theme_toggle.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';
import 'package:shop_mate/core/utils/layouts/responsive_scaffold.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/navigation_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/screens/dashboard/dashboard_screen.dart';
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
    final sidebarProv = Provider.of<NavigationProvider>(context);

    return ResponsiveScaffold(
      title: "N A I J A B I Z",
      // drawer: const MyDrawer(),
      // navigationRail: AnimatedContainer(
      //   duration: const Duration(milliseconds: 300),
      //   width: sidebarProv.isSidebarExpanded ? 100.w : 60,
      //   child: ResponsiveNavigation(userRole: UserRole.admin,),
      // ),
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
      body: Consumer<NavigationProvider>(builder: (context, navProvider, child){
        return navProvider.getActiveScreen(navProvider.selectedIndex).screen ?? const DashboardScreen();
      },),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: theme.colorScheme.primary,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       label: "HOME",
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.shopping_bag_outlined), label: "INVENTORY"),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       label: "CREDIT",
      //     ),
      //   ],
      // ),
      userRole: UserRole.admin,
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
        Provider.of<NavigationProvider>(context, listen: false)
            .setSelectedIndex(index);
      },
      selectedIndex: 0,
    );
  }
}
