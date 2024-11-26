abstract class OptionRepository {
  Future<void> saveSelection(String key, String value);
  Future<String> getSelection(String key);
}
