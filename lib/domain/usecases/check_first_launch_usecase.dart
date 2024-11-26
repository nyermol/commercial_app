import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckFirstLaunchUsecase {
  final ClearCubit clearCubit;

  CheckFirstLaunchUsecase({required this.clearCubit});

  Future<void> call(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isManualClearRequested =
        prefs.getBool('manualClearRequested') ?? false;
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isManualClearRequested || isFirstLaunch) {
      // ignore: use_build_context_synchronously
      await clearCubit.clearAllDataOnStart(context);
      await prefs.setBool('isFirstLaunch', false);
    }
  }
}
