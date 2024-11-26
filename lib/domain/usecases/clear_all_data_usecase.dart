import 'package:commercial_app/domain/repositories/clear_repository.dart';

class ClearAllDataUsecase {
  final ClearRepository repository;

  ClearAllDataUsecase(this.repository);

  Future<void> call() {
    return repository.clearAllData();
  }
}
