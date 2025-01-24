import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/main.dart';

class ErrorNotificationService {
  static void showErrorToaster({
    required String message,
    String? description,
    bool isDestructive = false,
  }) {
    if (navigatorKey.currentContext != null) {
      ShadToaster.of(navigatorKey.currentContext!).show(
        isDestructive
            ? ShadToast.destructive(
                title: Text(message),
                description: description != null ? Text(description) : null,
              )
            : ShadToast(
                title: Text(message),
                description: description != null ? Text(description) : null,
                backgroundColor: Colors.green[400],
              ),
      );
    }
  }
}
