import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/providers/theme_provider.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.title,
    this.shadowColor,
    this.darkthemeShadowColor,
  });
  final Text title;
  final Color? shadowColor;
  final Color? darkthemeShadowColor;

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);

    return ShadCard(
      title: title,
      shadows: !themeProv.isDarkTheme
          ? [
              BoxShadow(
                color: shadowColor ?? Colors.grey,
                blurStyle: BlurStyle.outer,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]
          : [
              BoxShadow(
                color: darkthemeShadowColor ?? Colors.green,
                blurStyle: BlurStyle.outer,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
    );
  }
}
