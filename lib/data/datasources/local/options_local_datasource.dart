import 'package:commercial_app/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OptionsLocalDatasource {
  Future<void> saveSelection(String key, String value);
  Future<String> getSelection(String key);
}

class OptionsLocalDatasourceImpl implements OptionsLocalDatasource {
  final SharedPreferences sharedPreferences;

  OptionsLocalDatasourceImpl(this.sharedPreferences);
  @override
  Future<void> saveSelection(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String> getSelection(String key) async {
    return sharedPreferences.getString(key) ?? S.current.no;
  }
}
