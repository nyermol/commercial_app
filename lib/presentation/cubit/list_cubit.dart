// ignore_for_file: always_specify_types

import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListCubit extends Cubit<Map<String, dynamic>> {
  final RemoveItemUsecase removeItemUsecase;
  final RestoreItemUsecase restoreItemUsecase;
  final SaveDataListUsecase saveDataListUsecase;
  final LoadDataListUsecase loadDataListUsecase;
  final RemoveImageUsecase removeImageUsecase;

  ListCubit({
    required this.removeItemUsecase,
    required this.restoreItemUsecase,
    required this.saveDataListUsecase,
    required this.loadDataListUsecase,
    required this.removeImageUsecase,
  }) : super({});

  Future<void> removeItem(String key, int index) async {
    await removeItemUsecase.call(key, index);
  }

  Future<void> restoreItem(String key) async {
    await restoreItemUsecase.call(key);
  }

  Future<void> saveDataList(
    String key,
    List<Map<String, dynamic>> dataList,
  ) async {
    await saveDataListUsecase.call(key, dataList);
    emit({...state, key: dataList});
  }

  Future<void> loadDataList(String key) async {
    await loadDataListUsecase.call(key);
  }

  Future<void> removeImage(String key, int itemIndex, String imagePath) async {
    await removeImageUsecase.call(key, itemIndex, imagePath);
  }
}
