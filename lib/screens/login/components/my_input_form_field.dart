import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/providers/theme_provider.dart';

class MyInputFormField extends StatelessWidget {
  const MyInputFormField(
      {super.key,
      required this.placeholder,
      this.keyboardType,
      this.validator,
      this.controller,
      this.obscureText});
  final String placeholder;
  final TextInputType? keyboardType;
  final String? Function(String)? validator;
  final TextEditingController? controller;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);

    return ShadInputFormField(
      placeholder: Text(placeholder),
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      decoration: ShadDecoration(
        shadows: ShadShadows.md,
      ),
      validator: validator,
    );
  }
}
