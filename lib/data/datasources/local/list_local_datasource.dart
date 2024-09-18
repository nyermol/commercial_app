// ignore_for_file: always_specify_types

import 'package:commercial_app/data/datasources/local/local_database_export.dart';

abstract class ListLocalDatasourse {
  Future<void> saveDataList(String key, List<Map<String, dynamic>> dataList);
  Future<List<Map<String, dynamic>>> fetchList(String key);
  Future<void> saveRemovedItem(
    String key,
    Map<String, dynamic> item,
    int index,
  );
  Future<Map<String, dynamic>?> fetchRemovedItem(String key);
}

class ListLocalDatasourseImpl implements ListLocalDatasourse {
  final DatabaseServices databaseServices;

  ListLocalDatasourseImpl({required this.databaseServices});

  @override
  Future<void> saveDataList(String key, List<Map<String, dynamic>> list) async {
    await databaseServices.update(key, {'list': list});
  }

  @override
  Future<List<Map<String, dynamic>>> fetchList(String key) async {
    Map<String, dynamic>? result = await databaseServices.fetch(key);
    if (result != null && result['list'] != null) {
      List<dynamic> dynamicList = result['list'];
      return dynamicList
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }

  @override
  Future<void> saveRemovedItem(
    String key,
    Map<String, dynamic> item,
    int index,
  ) async {
    await databaseServices.update(
      '$key-removed',
      {'item': item, 'index': index},
    );
  }

  @override
  Future<Map<String, dynamic>?> fetchRemovedItem(String key) async {
    return await databaseServices.fetch('$key-removed');
  }
}
