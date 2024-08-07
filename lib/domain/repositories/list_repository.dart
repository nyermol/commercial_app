abstract class ListRepository {
  Future<void> removeItem(String key, int index);
  Future<void> restoreItem(String key);
  Future<void> saveDataList(String key, List<Map<String, dynamic>> dataList);
  Future<void> loadDataList(String key);
  Future<void> removeImage(String key, int itemIndex, String imagePath);
}
