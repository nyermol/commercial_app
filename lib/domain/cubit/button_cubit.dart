// ignore_for_file: always_specify_types, use_build_context_synchronously

import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonCubit extends Cubit<Map<String, String>> {
  final SaveSelectionUsecase saveSelectionUsecase;
  final GetSelectionUsecase getSelectionUsecase;

  ButtonCubit(
    this.saveSelectionUsecase,
    this.getSelectionUsecase,
  ) : super({});

  Future<void> initializeDefaults(BuildContext context) async {
    if (state.isNotEmpty) return;
    for (String key in keys) {
      String value = await getSelectionUsecase.call(key);
      if (value.isEmpty) {
        value = S.of(context).no;
        await saveSelectionUsecase.call(key, value);
      }
      state[key] = value;
    }
    emit(Map.from(state));
  }

  Future<void> saveSelection(
    BuildContext context,
    String key,
    String value,
  ) async {
    await saveSelectionUsecase.call(key, value);
    state[key] = value;
    emit(Map.from(state));
  }

  Future<void> loadSelection(BuildContext context, String key) async {
    String value = await getSelectionUsecase.call(key);
    state[key] = value;
    emit(Map.from(state));
  }

  String getSelection(BuildContext context, String key) {
    return state[key] ?? S.of(context).no;
  }
}
