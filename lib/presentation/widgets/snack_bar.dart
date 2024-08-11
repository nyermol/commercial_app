import 'dart:io';

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message,
  Color backgroundColor, {
  SnackBarAction? action,
  VoidCallback? onCancelAction,
}) {
  if (Platform.isIOS) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          message: Text(message, textAlign: TextAlign.center),
          actions: <Widget>[
            if (onCancelAction != null)
              CupertinoActionSheetAction(
                child: Text(S.of(context).cancel),
                onPressed: () {
                  Navigator.pop(context);
                  onCancelAction();
                },
              ),
            CupertinoActionSheetAction(
              child: Text(S.of(context).ok),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  } else {
    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
    final SnackBar snackbar = SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      margin: getSnackBarMargin(context),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      action: action,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
