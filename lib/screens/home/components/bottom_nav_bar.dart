import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/providers/navigation_provider.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';

class BottomNavBar extends StatelessWidget {
  final UserRole userRole;

  const BottomNavBar({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final availableItems = navigationProvider.getAvailableItems(userRole);

    // Show only first 5 items for bottom nav bar
    final bottomNavItems = availableItems.length > 5 ? availableItems.sublist(0, 5) : availableItems;

    return BottomNavigationBar(
      currentIndex: navigationProvider.selectedIndex < bottomNavItems.length
          ? navigationProvider.selectedIndex
          : 0,
      onTap: (index) {
        navigationProvider.setSelectedIndex(index);
      },
      type: BottomNavigationBarType.fixed,
      items: bottomNavItems.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        );
      }).toList(),
    );
  }
}
