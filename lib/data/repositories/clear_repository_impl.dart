import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';

class ClearRepositoryImpl implements ClearRepository {
  final ClearLocalDatasource localDatasource;

  ClearRepositoryImpl({required this.localDatasource});

  @override
  Future<void> clearAllData() {
    return localDatasource.clearAllData();
  }
}
