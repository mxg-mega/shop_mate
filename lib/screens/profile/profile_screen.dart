import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/screens/profile/edit_profile_screen.dart';

import '../../core/utils/constants_enums.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sessionProv = Provider.of<SessionProvider>(context);

    Widget _customListTile(String title, String description) {
      return ListTile(
        title: Text(
          title,
          style: theme.textTheme.small,
        ),
        subtitle: sessionProv.isLoading
            ? const Text('...')
            : Text(description ?? '...'),
        subtitleTextStyle: theme.textTheme.p
            .copyWith(fontWeight: FontWeight.normal, fontSize: 18),
      );
    }

    return SingleChildScrollView(
      // padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.h),
      child: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: sessionProv.isLoading ? CircularProgressIndicator(color: ShadTheme.of(context).colorScheme.primary,) : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ShadAvatar(
              Bootstrap.person,
              size: Size(100, 100),
            ),
            Perimeter(
              height: 5,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350.w),
              child: ShadCard(
                title: Text(
                  "User Information",
                  style: theme.textTheme.h3,
                ),
                radius: BorderRadius.circular(20),
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: theme.colorScheme.primaryForeground),
                child: Column(
                  children: [
                    _customListTile("Name", sessionProv.userModel!.name),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    _customListTile("Email", sessionProv.userModel!.email),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    _customListTile("Phone Number",
                        sessionProv.userModel!.phoneNumber.toString()),
                    SizedBox(
                      height: 5.h,
                      child: Divider(
                        height: 3.h,
                      ),
                    ),
                    _customListTile(
                        "User Role", sessionProv.userModel!.role.name),
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
            Perimeter(height: 3),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350.w),
              child: ShadCard(
                title: const Text("Business Information"),
                child: Column(children: [
                  _customListTile("Name", sessionProv.business!.name),
                  SizedBox(
                    height: 5.h,
                    child: Divider(
                      height: 3.h,
                    ),
                  ),
                  _customListTile(
                      "Category", sessionProv.business!.businessType.name),
                  SizedBox(
                    height: 5.h,
                    child: Divider(
                      height: 3.h,
                    ),
                  ),
                  _customListTile("Phone", sessionProv.business!.phone),
                  SizedBox(
                    height: 5.h,
                    child: Divider(
                      height: 3.h,
                    ),
                  ),
                  _customListTile("Address", sessionProv.business!.address),
                  SizedBox(
                    height: 5.h,
                    child: Divider(
                      height: 3.h,
                    ),
                  ),
                  _customListTile("Subscription Tier",
                      sessionProv.business!.subscription.tier),
                  SizedBox(
                    height: 5.h,
                    child: Divider(
                      height: 3.h,
                    ),
                  ),
                  _customListTile("Currency",
                      sessionProv.business!.businessSettings!.currency),
                  SizedBox(
                    height: 5.h,
                    child: Divider(
                      height: 3.h,
                    ),
                  ),
                  _customListTile("UnitSystem",
                      sessionProv.business!.businessSettings!.unitSystem.name),
                ]),
              ),
            ),
            const Perimeter(height: 5),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150.w),
              child: ShadButton(
                mainAxisAlignment: MainAxisAlignment.center,
                height: 50.h,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          EditProfileScreen(sessionProvider: sessionProv),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                child: const Text("Edit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
