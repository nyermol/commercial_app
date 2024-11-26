// ignore_for_file: always_specify_types

import 'package:commercial_app/data/models/models_export.dart';
import 'package:hive/hive.dart';

abstract class RemarksLocalDatasource {
  Future<void> saveDataList(String key, List<Remark> dataList);
  Future<List<Remark>> fetchList(String key);
  Future<void> deleteRemark(String key, int index);
}

class RemarksLocalDatasourceImpl implements RemarksLocalDatasource {
  final Box<Remark> _remarksBox = Hive.box<Remark>('remarksBox');

  @override
  Future<void> saveDataList(String key, List<Remark> dataList) async {
    for (int i = 0; i < dataList.length; i++) {
      await _remarksBox.put('$key-$i', dataList[i]);
    }
  }

  @override
  Future<List<Remark>> fetchList(String key) async {
    return _remarksBox.keys
        .where((boxKey) => boxKey.toString().startsWith(key))
        .map((boxKey) => _remarksBox.get(boxKey)!)
        .toList();
  }

  @override
  Future<void> deleteRemark(String key, int index) async {
    await _remarksBox.delete('$key-$index');
  }
}
