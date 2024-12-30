import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/providers/sidebar_provider.dart';

class SideBarItem extends StatefulWidget {
  const SideBarItem({
    super.key,
    required this.icon,
    required this.tileText,
    this.tileTag, required this.index,
  });
  final Widget icon;
  final Widget tileText;
  final String? tileTag;
  final int index;

  @override
  State<SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem> {
  @override
  Widget build(BuildContext context) {
    final sidebarProv = Provider.of<SidebarProvider>(context);
    bool isSelected = false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0.w, horizontal: 12.0.w),
      child: ListTile(
        leading: widget.icon,
        title: sidebarProv.sidebarOpen ? widget.tileText : null,
        selected: isSelected,
        onTap: () {
          sidebarProv.setSelectedIndex(widget.index);
          sidebarProv.activeModule = widget.tileTag!;
        },
      ),
    );
  }
}
