import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/local/user_storage.dart';
import 'package:shop_mate/data/models/users/user_model.dart';
import 'package:shop_mate/screens/profile/edit_profile_screen.dart';
import '../../core/utils/constants_enums.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLogoutConfirmation(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => ShadDialog(
        title: const Text('Confirm Logout'),
        actions: [
          ShadButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              Navigator.of(ctx).pop();
              authProvider.logout(ctx);
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   '/login',
              //   (Route<dynamic> route) => false
              // );
            },
            child: const Text(
              'Logout',
            ),
          ),
        ],
        child: const Text('Are you sure you want to logout?'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final authProv = Provider.of<AuthenticationProvider>(context);
    final userProfile = authProv.currentUser ?? UserStorage.getUserProfile();
    final business =
        authProv.currentBusiness ?? BusinessStorage.getBusinessProfile();

    if (userProfile == null || business == null) {
      return Center(
        child: Text("Data not available. Please try again later."),
      );
    }

    Widget customListTile(String title, String? description) {
      return ListTile(
        title: Text(
          title,
          style: theme.textTheme.small,
        ),
        subtitle: Text(description ?? '...'),
        subtitleTextStyle: theme.textTheme.p.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 18,
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ShadAvatar(
              Bootstrap.person,
              size: Size(100, 100),
            ),
            const Perimeter(height: 5),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350.w),
              child: ShadCard(
                title: Text(
                  "User Information",
                  style: theme.textTheme.h3,
                ),
                radius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    customListTile("Name", userProfile.name),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile("Email", userProfile.email),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile(
                      "Phone Number",
                      userProfile.phoneNumber?.toString() ?? 'N/A',
                    ),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile(
                        "User Role", userProfile.role?.name ?? 'N/A'),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Perimeter(height: 3),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350.w),
              child: ShadCard(
                title: const Text("Business Information"),
                child: Column(
                  children: [
                    customListTile("Name", business.name),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile(
                        "Category", business.businessType?.name ?? 'N/A'),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile("Phone", business.phone),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile("Address", business.address),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile("Subscription Tier",
                        business.subscription?.tier ?? 'N/A'),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile("Currency",
                        business.businessSettings?.currency ?? 'N/A'),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    customListTile("UnitSystem",
                        business.businessSettings?.unitSystem?.name ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const Perimeter(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 150.w),
                  child: ShadButton(
                    mainAxisAlignment: MainAxisAlignment.center,
                    height: 50.h,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    child: const Text("Edit"),
                  ),
                ),
                SizedBox(width: 20.w),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 150.w),
                  child: ShadButton.destructive(
                    mainAxisAlignment: MainAxisAlignment.center,
                    height: 50.h,
                    onPressed: () => _showLogoutConfirmation(context),
                    icon: const Icon(Icons.logout),
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
