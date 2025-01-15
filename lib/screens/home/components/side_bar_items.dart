import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/providers/navigation_provider.dart';

class SideBarItem extends StatelessWidget {
  const SideBarItem({
    super.key,
    required this.icon,
    required this.tileText,
    required this.tileTag, required this.index,
  });
  final Widget icon;
  final Widget tileText;
  final String tileTag;
  final int index;

  @override
  Widget build(BuildContext context) {
    final sidebarProv = Provider.of<NavigationProvider>(context, listen: false);
    bool isSelected = false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical:  1.0.w, horizontal: sidebarProv.isSidebarExpanded ? 12.0.w : 2),
      child: ListTile(
        leading: icon,
        title: sidebarProv.isSidebarExpanded ? tileText : SizedBox(),
        selected: sidebarProv.selectedIndex == index,
        selectedTileColor: ShadTheme.of(context).colorScheme.selection,
        onTap: () {
          sidebarProv.setSelectedIndex(index);
          print("$index was selected");
        },
      ),
    );
  }
}
