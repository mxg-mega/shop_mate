import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool sidebarOpen = true;

  void toggleSideBar() {
    sidebarOpen = !sidebarOpen;
    notifyListeners();
  }
}
