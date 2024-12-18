import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({super.key});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Row(
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 7,
                ),
                shrinkWrap: true,
                children: [
                  ShadCard(
                    title: Text("N300,000.00", style: theme.textTheme.h3),
                  ),
                  ShadCard(
                    title: Text("N300,000.00", style: theme.textTheme.h3),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
