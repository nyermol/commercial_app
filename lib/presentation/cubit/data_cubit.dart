// ignore_for_file: always_specify_types

import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataCubit extends Cubit<Map<String, dynamic>> {
  final SaveTextUsecase saveTextUsecase;

  DataCubit({
    required this.saveTextUsecase,
  }) : super({});

  Future<void> saveText(String key, String text) async {
    await saveTextUsecase(key, text);
    emit({...state, key: text});
  }
}
