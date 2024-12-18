import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/components/theme_toggle.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';
import 'package:shop_mate/core/utils/layouts/responsive_scaffold.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/models/users/constants_enums.dart';
import 'package:shop_mate/providers/home_screen_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sessionProv = Provider.of<SessionProvider>(context);

    return ResponsiveScaffold(
      title: const Text(
        "N A I J A B I Z",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      drawer: const MyDrawer(),
      navigationRail: AnimatedSwitcher(
        child: myNavigationRail(context),
        duration: Duration(milliseconds: 300),
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
          },
        ),
      ],
      body: GridView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.0.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveLayout.isMobile(context) ? 1 : 2,
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
          mainAxisExtent: 200,
        ),
        shrinkWrap: true,
        children: [
          ShadCard(
            shadows: theme.cardTheme.shadows,
            backgroundColor: theme.cardTheme.backgroundColor,
            title: Text("N300,000.00", style: theme.textTheme.h3),
          ),
          ShadCard(
            shadows: theme.cardTheme.shadows,
            backgroundColor: theme.cardTheme.backgroundColor,
            title: Text("N300,000.00", style: theme.textTheme.h3),
          ),
          ShadCard(
            shadows: theme.cardTheme.shadows,
            backgroundColor: theme.cardTheme.backgroundColor,
            title: Text("N300,000.00", style: theme.textTheme.h3),
          ),
          ShadCard(
            title: Text("N3,000.00", style: theme.textTheme.h3),
          ),
          ShadCard(
            title: Text("N2000.00", style: theme.textTheme.h3),
          ),
          ShadCard(
            title: Text("N90,000.00", style: theme.textTheme.h3),
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
      indicatorShape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
              width: 150, color: ShadTheme.of(context).colorScheme.selection)),
      useIndicator: true,
      destinations: [
        NavigationRailDestination(
          indicatorColor: Colors.red,
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
      selectedIndex: 0,
      extended: Provider.of<HomeScreenProvider>(context).sidebarOpen,
    );
  }
}
