import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/themes/provider/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return ShadSwitch(
        value: themeProvider.isDarkTheme,
        padding: const EdgeInsets.only(right: 10),
        onChanged: (v) {
          themeProvider.toggleTheme();
        },
        label: themeProvider.isDarkTheme
            ? const Text('Dark')
            : const Text('light'),
      );
  }
}