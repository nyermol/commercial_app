// ignore_for_file: require_trailing_commas

import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/datasources/remote/remarks_remote_datasource.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:hive/hive.dart';

class ListRepositoryImpl implements ListRepository {
  final ListLocalDatasource listLocalDatasource;
  final RemarksRemoteDatasource remarksRemoteDatasource;

  ListRepositoryImpl({
    required this.listLocalDatasource,
    required this.remarksRemoteDatasource,
  });

  @override
  Future<void> saveDataList(
      String key, List<Map<String, dynamic>> dataList) async {
    await listLocalDatasource.saveDataList(key, dataList);
  }

  @override
  Future<List<Map<String, dynamic>>> loadDataList(String key) async {
    return await listLocalDatasource.fetchList(key);
  }

  @override
  @override
  Future<void> removeImage(String key, int itemIndex, String imagePath) async {
    List<Map<String, dynamic>> currentList =
        await listLocalDatasource.fetchList(key);
    if (itemIndex < currentList.length) {
      List<String> images = List<String>.from(
        currentList[itemIndex]['images'] ?? <List<String>>[],
      );
      if (images.contains(imagePath)) {
        images.remove(imagePath);
        currentList[itemIndex]['images'] = images;
        await listLocalDatasource.saveDataList(key, currentList);
        await Hive.box('imagesBox').delete(imagePath);
      }
    }
  }
}
