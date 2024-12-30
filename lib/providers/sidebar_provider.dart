import 'package:flutter/material.dart';
import 'package:shop_mate/screens/dashboard/dashboard_screen.dart';

class SidebarProvider extends ChangeNotifier {
  bool sidebarOpen = true;
  int _selectedNavigationRailIndex = 0;
  String _activeModule = 'dashboard';

  set activeModule(String value) {
    _activeModule = value;
    notifyListeners();
  }

  Map<String, dynamic> get getModule {
    return {
      'name': _activeModule,
      'index': _selectedNavigationRailIndex,
    };
  }

  void toggleSideBar() {
    sidebarOpen = !sidebarOpen;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedNavigationRailIndex = index;
    notifyListeners();
  }

  Widget moduleContentBuilder(String module, int moduleIndex) {
    switch (moduleIndex) {
      case 0:
        return const DashboardScreen();
      default:
        return const DashboardScreen();
    }
  }
}
