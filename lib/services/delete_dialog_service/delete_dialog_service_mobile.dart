import 'dart:io' show Platform;
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialogImpl({
  required BuildContext context,
  required int index,
  required void Function(int) onDelete,
  required void Function() onCancel,
  required String currentItem,
  required void Function(String, int) onSave,
}) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(
          S.of(context).removeRemark,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: mainFontSize,
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              onDelete(index);
            },
            child: Text(
              S.of(context).yes,
              style: const TextStyle(
                fontSize: mainFontSize,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              onCancel();
            },
            child: Text(
              S.of(context).no,
              style: TextStyle(
                fontSize: mainFontSize,
                color: mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    return showCustomDialog(
      context: context,
      title: S.of(context).removeRemark,
      content: const SizedBox.shrink(),
      actions: <Widget>[
        TextButton(
          child: Text(
            S.of(context).yes,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onDelete(index);
          },
        ),
        TextButton(
          child: Text(
            S.of(context).no,
            style: TextStyle(
              fontSize: mainFontSize,
              color: mainColor,
            ),
          ),
          onPressed: () {
            onCancel();
          },
        ),
      ],
    );
  }
}
