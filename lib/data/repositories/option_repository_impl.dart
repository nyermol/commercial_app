import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';

class OptionRepositoryImpl implements OptionRepository {
  final OptionsLocalDatasource localDatasource;

  OptionRepositoryImpl(this.localDatasource);
  @override
  Future<void> saveSelection(String key, String value) {
    return localDatasource.saveSelection(key, value);
  }

  @override
  Future<String> getSelection(String key) {
    return localDatasource.getSelection(key);
  }
}
