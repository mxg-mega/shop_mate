import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/providers/sidebar_provider.dart';

class MySidebar extends StatefulWidget {
  const MySidebar({
    super.key,
  });

  @override
  State<MySidebar> createState() => _MySidebarState();
}

class _MySidebarState extends State<MySidebar> {
  int selectedIndex = 0;
  String activeModule = 'dashboard';
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    final sidebarProv = Provider.of<SidebarProvider>(context);
    isExtended = sidebarProv.sidebarOpen;
    
    return Container();
  }
}
