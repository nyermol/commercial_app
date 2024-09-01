import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';

class DataRepositoryImpl implements DataRepository {
  final DataLocalDatasource dataLocalDatasource;

  DataRepositoryImpl({required this.dataLocalDatasource});

  @override
  Future<void> saveText(String key, String text) async {
    await dataLocalDatasource.saveText(key, text);
  }
}
