import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/components/theme_toggle.dart';
import 'package:shop_mate/core/utils/layouts/responsive_layout.dart';
import 'package:shop_mate/core/utils/layouts/responsive_scaffold.dart';
import 'package:shop_mate/core/utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ResponsiveScaffold(
      title: Text(
        "M A T J A R",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      drawer: Expanded(flex: 2, child: myDrawer(context)),
      actions: [
        ThemeToggle(),
      ],
      body: GridView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveLayout.isMobile(context) ? 1 : 5,
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
        ],
      ),
    );
  }
}
