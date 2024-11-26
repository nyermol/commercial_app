import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor, {
  SnackBarAction? action,
  VoidCallback? onAction,
}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  final SnackBar snackbar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: subtitleFontSize,
      ),
    ),
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(
      seconds: 5,
    ),
    action: action,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
