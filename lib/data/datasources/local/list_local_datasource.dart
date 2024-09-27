// ignore_for_file: always_specify_types, require_trailing_commas

import 'package:hive/hive.dart';

abstract class ListLocalDatasource {
  Future<void> saveDataList(String key, List<Map<String, dynamic>> dataList);
  Future<List<Map<String, dynamic>>> fetchList(String key);
  Future<void> saveRemovedItem(
      String key, Map<String, dynamic> item, int index);
  Future<Map<String, dynamic>> fetchRemovedItem(String key);
}

class ListLocalDatasourceImpl implements ListLocalDatasource {
  final Box<Map<String, dynamic>> _box = Hive.box('my_box');

  @override
  Future<void> saveDataList(
      String key, List<Map<String, dynamic>> dataList) async {
    await _box.put(key, {'list': dataList});
  }

  @override
  Future<List<Map<String, dynamic>>> fetchList(String key) async {
    final data = _box.get(key);
    if (data != null && data['list'] != null) {
      return List<Map<String, dynamic>>.from(data['list']);
    }
    return <Map<String, dynamic>>[];
  }

  @override
  Future<void> saveRemovedItem(
      String key, Map<String, dynamic> item, int index) async {
    await _box.put('$key-removed', {'item': item, 'index': index});
  }

  @override
  Future<Map<String, dynamic>> fetchRemovedItem(String key) async {
    final data = _box.get('$key-removed');
    if (data != null && data['item'] != null) {
      return Map<String, dynamic>.from(data['item']);
    }
    return <String, dynamic>{};
  }
}
