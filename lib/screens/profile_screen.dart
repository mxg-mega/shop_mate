import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/providers/session_provider.dart';

import '../core/utils/constants_enums.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final sessionProv = Provider.of<SessionProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ShadAvatar(
            Bootstrap.person,
            size: Size(100, 100),
          ),
          Perimeter(height: 5,),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350.w),
            child: ShadCard(
              title: Text("User Information", style: theme.textTheme.h3,),
              radius: BorderRadius.circular(20),
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: theme.colorScheme.primaryForeground),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Name",
                      style: theme.textTheme.small,
                    ),
                    subtitle: sessionProv.isLoading ? const Text('...') : Text(sessionProv!.userModel!.name ?? '...'),
                    subtitleTextStyle: theme.textTheme.p.copyWith(fontWeight: FontWeight.normal, fontSize: 18),

                  ),
                  SizedBox(height: 5.h,child: Divider(height: 3.h,),),
                  ListTile(
                    title: Text(
                      "Email",
                      style: theme.textTheme.small,
                    ),
                    subtitle: !sessionProv.isLoading ? Text(sessionProv.userModel!.email ?? '...') : const Text('...'),
                    subtitleTextStyle: theme.textTheme.p.copyWith(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  SizedBox(height: 5.h,child: Divider(height: 3.h,),),
                  ListTile(
                    title: Text(
                      "Role",
                      style: theme.textTheme.small,
                    ),
                    subtitle: !sessionProv.isLoading ? Text(sessionProv.userModel!.role.name ?? '...') : const Text('...'),
                    subtitleTextStyle: theme.textTheme.p.copyWith(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  SizedBox(height: 5.h,child: Divider(height: 3.h,),),
                ],
              ),
            ),
          ),
          Perimeter(height: 3),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350.w),
            child: ShadCard(
              title: Text("Business Information"),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      "Role",
                      style: theme.textTheme.small,
                    ),
                    subtitle: !sessionProv.isLoading ? Text(sessionProv.userModel!.role.name ?? '...') : const Text('...'),
                    subtitleTextStyle: theme.textTheme.p.copyWith(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                  SizedBox(height: 5.h,child: Divider(height: 3.h,),),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
}
