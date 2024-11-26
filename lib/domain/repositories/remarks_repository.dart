import 'package:commercial_app/data/models/models_export.dart';

abstract class RemarksRepository {
  Future<void> saveDataList(String key, List<Remark> dataList);
  Future<List<Remark>> loadDataList(String key);
  Future<void> removeImage(String key, int itemIndex, String imagePath);
  Future<void> deleteRemark(String key, int index);
}
