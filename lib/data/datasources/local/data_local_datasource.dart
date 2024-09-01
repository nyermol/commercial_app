import 'package:shared_preferences/shared_preferences.dart';

abstract class DataLocalDatasource {
  Future<void> saveText(String key, String text);
}

class DataLocalDatasourceImpl implements DataLocalDatasource {
  final SharedPreferences sharedPreferences;

  DataLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveText(String key, String text) async {
    await sharedPreferences.setString(key, text);
  }
}
