import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'date_picker_service.dart';

class DatePickerServiceImpl implements DatePickerService {
  @override
  Future<DateTime?> pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    return await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: S.of(context).inspectionDateEnter,
    );
  }
}
