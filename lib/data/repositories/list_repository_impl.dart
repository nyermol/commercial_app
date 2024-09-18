import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/datasources/remote/remarks_remote_datasource.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:hive/hive.dart';

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
  Future<void> saveDataList(
    String key,
    List<Map<String, dynamic>> dataList,
  ) async {
    await listLocalDatasourse.saveDataList(key, dataList);
  }

  @override
  Future<List<Map<String, dynamic>>> loadDataList(String key) async {
    return await listLocalDatasourse.fetchList(key);
  }

  @override
  @override
  Future<void> removeImage(String key, int itemIndex, String imagePath) async {
    List<Map<String, dynamic>> currentList =
        await listLocalDatasourse.fetchList(key);
    if (itemIndex < currentList.length) {
      List<String> images = List<String>.from(
        currentList[itemIndex]['images'] ?? <List<String>>[],
      );
      if (images.contains(imagePath)) {
        images.remove(imagePath);
        currentList[itemIndex]['images'] = images;
        await listLocalDatasourse.saveDataList(key, currentList);
        await Hive.box('imagesBox').delete(imagePath);
      }
    }
  }
}
