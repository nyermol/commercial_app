import 'package:commercial_app/domain/repositories/list_repository.dart';

class RestoreItemUsecase {
  final ListRepository repository;

  RestoreItemUsecase(this.repository);

  Future<void> call(String key) async {
    return repository.restoreItem(key);
  }
}
