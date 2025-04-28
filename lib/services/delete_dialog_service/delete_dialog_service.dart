import 'package:flutter/widgets.dart';

import 'delete_dialog_service_mobile.dart'
    if (dart.library.html) 'delete_dialog_service_web.dart';

// Интерфейс демонстрации Alert Dialog для удаления элементов
Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required int index,
  required Function(int) onDelete,
  required Function() onCancel,
  required String currentItem,
  required Function(String, int) onSave,
}) =>
    showDeleteConfirmationDialogImpl(
      context: context,
      index: index,
      onDelete: onDelete,
      onCancel: onCancel,
      currentItem: currentItem,
      onSave: onSave,
    );
