import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shop_mate/features/migration/UI/migration_screen.dart';
import 'package:shop_mate/screens/dashboard/dashboard_screen.dart';
import 'package:shop_mate/screens/expenses_screen.dart';
import 'package:shop_mate/screens/inventory/inventory_screen.dart';
import 'package:shop_mate/screens/products/products_screen.dart';
import 'package:shop_mate/screens/profile/profile_screen.dart';
import 'package:shop_mate/screens/sales_screen.dart';
import 'package:shop_mate/screens/settings_screen.dart';
import 'package:shop_mate/screens/transaction/transaction_screen.dart';
import 'package:shop_mate/screens/zakat_screen.dart';
import 'package:shop_mate/widgets/layout/responsive_product_grid.dart';
import '../core/utils/constants_enums.dart';
import '../screens/home/navigation_item_model.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = false;

  int get selectedIndex => _selectedIndex;
  bool get isSidebarExpanded => _isSidebarExpanded;

  /// List of navigation items.
  /// Note: Using `const` for the screens is ideal if they are immutable.
  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Bootstrap.house,
      allowedRoles: [UserRole.admin, UserRole.manager, UserRole.employee],
      screen: DashboardScreen(),
    ),
    NavigationItem(
      id: 'inventory',
      label: 'Inventory',
      icon: Bootstrap.box_seam,
      allowedRoles: [UserRole.admin, UserRole.manager],
      screen: InventoryScreen(),
    ),
    NavigationItem(
      id: 'products',
      label: 'Products',
      icon: LucideIcons.package2,
      allowedRoles: [UserRole.admin, UserRole.manager],
      screen: ProductsScreen(),
    ),
    NavigationItem(
      id: 'sales',
      label: 'Sales',
      icon: Bootstrap.cart,
      allowedRoles: [UserRole.admin, UserRole.manager, UserRole.employee],
      screen: SalesScreen(),
    ),
    NavigationItem(
      id: 'expenses',
      label: 'Expenses',
      icon: Bootstrap.cash_stack,
      allowedRoles: [UserRole.admin, UserRole.accountant],
      screen: ExpensesScreen(),
    ),
    NavigationItem(
      id: 'zakat',
      label: 'Zakat Tracker',
      icon: Bootstrap.calendar_check,
      allowedRoles: [UserRole.admin, UserRole.accountant],
      screen: ZakatScreen(),
    ),
    NavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: LucideIcons.settings,
      allowedRoles: [UserRole.admin, UserRole.staff],
      screen: SettingsScreen(),
    ),
    NavigationItem(
        allowedRoles: [UserRole.admin, UserRole.staff],
        id: 'transactions',
        label: 'Transactions',
        icon: LucideIcons.terminalSquare,
        screen: TransactionScreen()),
    NavigationItem(
      id: 'profile',
      label: 'Profile',
      icon: LucideIcons.user, // Changed to a more appropriate profile icon.
      allowedRoles: [UserRole.admin, UserRole.staff],
      screen: ProfileScreen(),
    ),
    NavigationItem(
      id: 'migartion',
      label: 'Migrations',
      icon: Icons.transfer_within_a_station,
      allowedRoles: [UserRole.admin],
      screen: MigrationScreen(),
    ),
  ];

  List<NavigationItem> getAvailableItems(UserRole userRole) {
    return _navigationItems
        .where((item) => item.allowedRoles.contains(userRole))
        .toList();
  }

  NavigationItem get activeItem => _navigationItems[_selectedIndex];

  void toggleSidebar() {
    _isSidebarExpanded = !_isSidebarExpanded;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
