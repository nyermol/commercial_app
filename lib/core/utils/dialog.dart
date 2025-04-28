import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:flutter/material.dart';

// Типизированное диалоговое окно
Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget>? actions,
  bool barrierDismissible = false,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: mainFontSize,
          ),
        ),
        content: content,
        actions: actions,
      );
    },
  );
}
