// ignore_for_file: always_specify_types

import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemarksCubit extends Cubit<Map<String, List<Remark>>> {
  final SaveDataListUsecase saveDataListUsecase;
  final LoadDataListUsecase loadDataListUsecase;
  final RemoveImageUsecase removeImageUsecase;
  final DeleteRemarkUsecase deleteRemarkUsecase;

  RemarksCubit({
    required this.saveDataListUsecase,
    required this.loadDataListUsecase,
    required this.removeImageUsecase,
    required this.deleteRemarkUsecase,
  }) : super({});

  Future<void> saveDataList(
    String key,
    List<Remark> dataList,
  ) async {
    await saveDataListUsecase.call(key, dataList);
    emit(<String, List<Remark>>{...state, key: dataList});
  }

  Future<void> loadDataList(String key) async {
    List<Remark> dataList = await loadDataListUsecase.call(key);
    emit(<String, List<Remark>>{...state, key: dataList});
  }

  Future<void> removeImage(String key, int itemIndex, String imagePath) async {
    await removeImageUsecase.call(key, itemIndex, imagePath);
    List<Remark> updatedList = await loadDataListUsecase.call(key);
    emit(<String, List<Remark>>{...state, key: updatedList});
  }

  Future<void> deleteRemark(String key, int index) async {
    await deleteRemarkUsecase.call(key, index);
    List<Remark> updatedList = await loadDataListUsecase.call(key);
    emit(<String, List<Remark>>{...state, key: updatedList});
  }

  void updateSelectedRooms(List<String> selectedRoomNames) {
    final Map<String, List<Remark>> updatedState =
        state.map((String key, List<Remark> remarks) {
      final List<Remark> updatedRemarks = remarks.map((Remark remark) {
        if (remark.subtitle.isNotEmpty &&
            !selectedRoomNames.contains(remark.subtitle)) {
          return remark.copyWith(subtitle: '');
        }
        return remark;
      }).toList();
      return MapEntry(key, updatedRemarks);
    });
    emit(updatedState);
  }
}
