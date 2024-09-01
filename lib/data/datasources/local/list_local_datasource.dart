// ignore_for_file: always_specify_types

import 'dart:convert';

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
    String jsonString = jsonEncode(list);
    await databaseServices.update(key, jsonString);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchList(String key) async {
    String? jsonString = await databaseServices.fetch(key);
    if (jsonString != null) {
      List<dynamic> dynamicList = jsonDecode(jsonString);
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
      jsonEncode(<String, Object>{'item': item, 'index': index}),
    );
  }

  @override
  Future<Map<String, dynamic>?> fetchRemovedItem(String key) async {
    String? jsonString = await databaseServices.fetch('$key-removed');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }
}
