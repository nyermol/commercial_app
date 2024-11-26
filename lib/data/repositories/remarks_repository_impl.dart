import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class RemarksRepositoryImpl implements RemarksRepository {
  final RemarksLocalDatasource remarksLocalDatasource;

  RemarksRepositoryImpl({
    required this.remarksLocalDatasource,
  });

  @override
  Future<void> saveDataList(
    String key,
    List<Remark> dataList,
  ) async {
    await remarksLocalDatasource.saveDataList(key, dataList);
  }

  @override
  Future<List<Remark>> loadDataList(String key) async {
    return await remarksLocalDatasource.fetchList(key);
  }

  @override
  Future<void> removeImage(String key, int itemIndex, String imagePath) async {
    List<Remark> currentList = await remarksLocalDatasource.fetchList(key);
    if (itemIndex < currentList.length) {
      Remark remark = currentList[itemIndex];
      // ignore: always_specify_types
      List<String> updatedImages = List.from(remark.images)..remove(imagePath);
      currentList[itemIndex] = remark.copyWith(images: updatedImages);
      final Box<Uint8List> imagesBox = Hive.box<Uint8List>('imagesBox');
      await remarksLocalDatasource.saveDataList(key, currentList);
      await imagesBox.delete(imagePath);
    }
  }

  @override
  Future<void> deleteRemark(String key, int index) async {
    await remarksLocalDatasource.deleteRemark(key, index);
  }
}
