import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';

void ErrorToaster(
    {required BuildContext context,
    required String message,
    String? description,
    bool isDestructive = false}) {
  ShadToaster.of(context).show(isDestructive
      ? ShadToast.destructive(
          title: Text(message),
          description: description != null ? Text(description) : null,
        )
      : ShadToast(
          title: Text(message),
          description: description != null ? Text(description) : null,
          backgroundColor: Colors.green[400],
        ));
}
