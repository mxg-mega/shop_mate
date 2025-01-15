import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shop_mate/screens/dashboard/dashboard_screen.dart';
import 'package:shop_mate/screens/expenses_screen.dart';
import 'package:shop_mate/screens/inventory_screen.dart';
import 'package:shop_mate/screens/sales_screen.dart';
import 'package:shop_mate/screens/zakat_screen.dart';
import '../models/users/constants_enums.dart';
import '../screens/home/navigation_item_model.dart';

class SidebarProvider extends ChangeNotifier {
  bool _isSidebarExpanded = true;
  int _selectedIndex = 0;
  String _activeModule = 'dashboard';

  int get selectedIndex => _selectedIndex;
  bool get isSidebarExpanded => _isSidebarExpanded;

  final List<NavigationItem> _navigationItems = const [
    NavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Bootstrap.house,
      allowedRoles: [UserRole.admin, UserRole.manager, UserRole.employee],
      screen: const DashboardScreen(),
    ),
    NavigationItem(
      id: 'inventory',
      label: 'Inventory',
      icon: Bootstrap.box_seam,
      allowedRoles: [UserRole.admin, UserRole.manager],
      screen: const InventoryScreen(),
    ),
    NavigationItem(
      id: 'sales',
      label: 'Sales',
      icon: Bootstrap.cart,
      allowedRoles: [UserRole.admin, UserRole.manager, UserRole.employee],
      screen: const SalesScreen(),
    ),
    NavigationItem(
      id: 'expenses',
      label: 'Expenses',
      icon: Bootstrap.cash_stack,
      allowedRoles: [UserRole.admin, UserRole.accountant],
      screen: const ExpensesScreen(),
    ),
    NavigationItem(
      id: 'zakat',
      label: 'Zakat Tracker',
      icon: Bootstrap.calendar_check,
      allowedRoles: [UserRole.admin, UserRole.accountant],
      screen: const ZakatScreen(),
    ),
  ];

  List<NavigationItem> getAvailableItems(UserRole userRole) {
    return _navigationItems.where(
            (item) => item.allowedRoles.contains(userRole)
    ).toList();
  }

  set activeModule(String value) {
    _activeModule = value;
    notifyListeners();
  }

  void toggleSideBar() {
    _isSidebarExpanded = !_isSidebarExpanded;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

}
