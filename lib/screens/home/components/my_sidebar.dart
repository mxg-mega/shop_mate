import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/local/user_storage.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/navigation_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/screens/home/components/side_bar_items.dart';
import 'package:shop_mate/screens/home/navigation_item_model.dart';
import 'package:shop_mate/services/auth_services.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/constants_enums.dart';

class ResponsiveNavigation extends StatelessWidget {
  const ResponsiveNavigation({
    super.key,
    required this.userRole,
  });

  final UserRole userRole;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sidebarProv = Provider.of<NavigationProvider>(context);
    final authService = MyAuthService();
    final availableItems = sidebarProv.getAvailableItems(userRole);
    bool isExtended = sidebarProv.isSidebarExpanded;

    Widget _buildHeader(BuildContext context) {
      final theme = ShadTheme.of(context);
      final navProvider = Provider.of<NavigationProvider>(context);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder(
                  tween: Tween<double>(
                    begin: 0,
                    end: navProvider.isSidebarExpanded ? 1.0 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    if (value < 1) {
                      return Icon(
                        Icons.shopping_bag_outlined,
                        size: 32,
                        color: theme.colorScheme.primary,
                      );
                    }

                    return Icon(
                      Icons.shopping_bag_outlined,
                      size: 25.w,
                      color: theme.colorScheme.primary,
                    );
                  }),
              Divider()
            ],
          ),
        ),
      );
    }

    Widget _buildNavItem(BuildContext context, NavigationItem item, int index) {
      final theme = ShadTheme.of(context);
      final navProvider = Provider.of<NavigationProvider>(context);
      final isSelected = navProvider.selectedIndex == index;

      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Material(
          color: isSelected ? theme.colorScheme.selection : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => navProvider.setSelectedIndex(index),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 24,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.foreground,
                  ),
                  TweenAnimationBuilder(
                    tween: Tween<double>(
                      begin: 0,
                      end: navProvider.isSidebarExpanded ? 1 : 0,
                    ),
                    duration: Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      // Only render the text when animation is complete
                      if (value < 1) return const SizedBox.shrink();
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              item.label.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: theme.textTheme.list.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.foreground,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
/*                  // if (navProvider.isSidebarExpanded) ...[
                  //   const SizedBox(width: 12),
                  //   Flexible(
                  //     flex: 5,
                  //     child: AnimatedOpacity(
                  //       duration: Duration(milliseconds: 400),
                  //       opacity: navProvider.isSidebarExpanded ? 1.0 : 0.0,
                  //       curve: Curves.easeInOut,
                  //       child: Text(
                  //         overflow: TextOverflow.ellipsis,
                  //         softWrap: true,
                  //         maxLines: 1,
                  //         item.label.toUpperCase(),
                  //         style: theme.textTheme.list.copyWith(
                  //           color: isSelected
                  //               ? theme.colorScheme.primary
                  //               : theme.colorScheme.foreground,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],*/
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: sidebarProv.isSidebarExpanded ? 240 : 70,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            boxShadow: [
              BoxShadow(
                color: theme.cardTheme.shadows!.first.color.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: _buildHeader(context),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableItems.length,
                  itemBuilder: (context, index) => _buildNavItem(
                    context,
                    availableItems[index],
                    index,
                  ),
                ),
              ),
              if (isExtended)
                ListTile(
                  leading: const Icon(
                    LucideIcons.logOut,
                    color: Colors.red,
                  ),
                  title: Text(
                    "LOGOUT",
                    style: ShadTheme.of(context).textTheme.p.copyWith(
                          color: Colors.red,
                        ),
                  ),
                  onTap: () {
                    // sessionProv.auth.signOut();
                    // sessionProv.clearSession();
                    authService.signOut();
                    UserStorage.logout();
                    BusinessStorage.logout();
                    // Navigator.of(context).pushReplacementNamed('/login');
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
