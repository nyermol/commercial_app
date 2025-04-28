import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/dialog.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialogImpl({
  required BuildContext context,
  required int index,
  required void Function(int) onDelete,
  required void Function() onCancel,
  required String currentItem,
  required void Function(String, int) onSave,
}) {
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
