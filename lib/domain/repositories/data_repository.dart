abstract class DataRepository {
  Future<void> saveText(
    String key,
    String text,
  );
}
