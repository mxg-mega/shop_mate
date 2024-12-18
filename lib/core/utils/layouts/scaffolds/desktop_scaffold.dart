import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: Container(
        color: ShadTheme.of(context).colorScheme.background,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: MyDrawer(),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 7,
                    ),
                    shrinkWrap: true,
                    children: [
                      ShadCard(
                        title: Text("N300,000.00", style: theme.textTheme.h3),
                        height: 150,
                        width: 200,
                      ),
                      ShadCard(
                        title: Text("N300,000.00", style: theme.textTheme.h3),
                        height: 150,
                        width: 200,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
