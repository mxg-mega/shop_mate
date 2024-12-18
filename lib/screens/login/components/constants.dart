import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/constants.dart';

Widget importantLabel(String label, BuildContext context) {
  return Row(children: [
    Text(label),
    Text('*', style: ShadTheme.of(context).destructiveAlertTheme.titleStyle)
  ]);
}

String? validate(var value, String message, var nullValue,
    Map<String, dynamic> infoDict, Map<String, dynamic> info) {
  try {
    if (value.length < nullValue) {
      return message;
    }
  } catch (e) {
    if (value == nullValue) {
      return message;
    }
  }
  infoDict.addAll(info);
  return null;
}
