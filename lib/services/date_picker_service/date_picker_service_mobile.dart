import 'dart:io' show Platform;
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'date_picker_service.dart';

class DatePickerServiceImpl implements DatePickerService {
  @override
  Future<DateTime?> pickDate(BuildContext context) async {
    DateTime? picked;
    if (Platform.isIOS) {
      DateTime cupertinoInitialDate = DateTime(2000, 1, 1);
      await showCupertinoModalPopup(
        context: context,
        barrierDismissible: true,
        builder: (_) => Container(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          height: SizeConfig.screenHeight * 0.3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: cupertinoInitialDate,
            minimumDate: DateTime(2000),
            maximumDate: DateTime(2100),
            onDateTimeChanged: (DateTime newDate) {
              picked = newDate;
            },
          ),
        ),
      );
      return picked;
    } else {
      DateTime initialDate = DateTime.now();
      final DateTime? result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        helpText: S.of(context).inspectionDateEnter,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: mainColor,
                    secondary: mainColor,
                  ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: subtitleFontSize,
                  ),
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      return result;
    }
  }
}
