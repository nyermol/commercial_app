abstract class ListRepository {
  Future<void> saveDataList(String key, List<Map<String, dynamic>> dataList);
  Future<List<Map<String, dynamic>>> loadDataList(String key);
  Future<void> removeImage(String key, int itemIndex, String imagePath);
}
