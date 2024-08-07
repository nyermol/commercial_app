// ignore_for_file: always_specify_types

import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonCubit extends Cubit<Map<String, String>> {
  final SaveSelectionUsecase saveSelectionUsecase;
  final GetSelectionUsecase getSelectionUsecase;

  ButtonCubit(
      super.initialState, this.saveSelectionUsecase, this.getSelectionUsecase,);

  Future<void> initializeDefaults(BuildContext context) async {
    for (String key in keys) {
      if (!state.containsKey(key)) {
        String value = getSelection(context, key);
        if (value == S.of(context).no) {
          state[key] = value;
        }
      }
    }
    emit(Map.from(state));
  }

  Future<void> saveSelection(
      BuildContext context, String key, String value,) async {
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
