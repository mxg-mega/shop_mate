import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/components/theme_toggle.dart';
import 'package:shop_mate/features/responsive_design/layouts/responsive_scaffold.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/providers/navigation_provider.dart';
import 'package:shop_mate/providers/authentication_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String title = "S H O P MATE";

  void _showLogoutConfirmation(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => ShadDialog(
        title: const Text('Confirm Logout'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              Navigator.of(ctx).pop();
              authProvider.logout(context);
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/login', (Route<dynamic> route) => false);
            },
            child: const Text(
              'Logout',
              // style: TextStyle(color: Colors.red),
            ),
          ),
        ],
        // content: const Text('Are you sure you want to logout?'),
        child: const Text('Are you sure you want to logout?'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavigationProvider>(context, listen: false)
          .setSelectedIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return ResponsiveScaffold(
      title: title,
      actions: [
        const ThemeToggle(),
        IconButton(
          icon: const Icon(LucideIcons.logOut),
          onPressed: () => _showLogoutConfirmation(context),
        ),
      ],
      body: navigationProvider.activeItem.screen,
      userRole: UserRole.admin,
    );
  }
}
