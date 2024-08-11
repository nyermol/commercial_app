import 'dart:io';

import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/datasources/remote/remarks_remote_datasource.dart';
import 'package:commercial_app/domain/repositories/domain_reposirories_export.dart';

class ListRepositoryImpl implements ListRepository {
  final ListLocalDatasourse listLocalDatasourse;
  final RemarksRemoteDatasource remarksRemoteDatasource;

  ListRepositoryImpl({
    required this.listLocalDatasourse,
    required this.remarksRemoteDatasource,
  });

  @override
  Future<void> removeItem(String key, int index) async {
    List<Map<String, dynamic>> currentList =
        await listLocalDatasourse.fetchList(key);
    if (index < currentList.length) {
      Map<String, dynamic> removedItem = currentList[index];
      currentList.removeAt(index);
      await listLocalDatasourse.saveDataList(key, currentList);
      await listLocalDatasourse.saveRemovedItem(key, removedItem, index);
    }
  }

  @override
  Future<void> restoreItem(String key) async {
    Map<String, dynamic>? lastRemovedItem =
        await listLocalDatasourse.fetchRemovedItem(key);
    if (lastRemovedItem!.isNotEmpty) {
      List<Map<String, dynamic>> currentList =
          await listLocalDatasourse.fetchList(key);
      currentList.insert(lastRemovedItem['index'], lastRemovedItem['item']);
      await listLocalDatasourse.saveDataList(key, currentList);
    }
  }

  @override
  Future<void> saveDataList(
    String key,
    List<Map<String, dynamic>> dataList,
  ) async {
    await listLocalDatasourse.saveDataList(key, dataList);
  }

  @override
  Future<void> loadDataList(String key) async {
    await listLocalDatasourse.fetchList(key);
  }

  @override
  Future<void> removeImage(String key, int itemIndex, String imagePath) async {
    List<Map<String, dynamic>> currentList =
        await listLocalDatasourse.fetchList(key);
    if (itemIndex < currentList.length) {
      List<String> images =
          // ignore: always_specify_types
          List<String>.from(currentList[itemIndex]['images'] ?? []);
      if (images.contains(imagePath)) {
        images.remove(imagePath);
        currentList[itemIndex]['images'] = images;
        await listLocalDatasourse.saveDataList(key, currentList);
        await File(imagePath).delete();
      }
    }
  }
}
