import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Widget importantLabel(String label, BuildContext context) {
  return Row(children: [
    Text(label),
    Text('*', style: ShadTheme.of(context).destructiveAlertTheme.titleStyle)
  ]);
}

String? validate(var value, String message, var nullValue) {
  try {
    if (value.length <= nullValue) {
      return message;
    }
  } catch (e) {
    if (value == nullValue) {
      return message;
    }
  }

  return null;
}
