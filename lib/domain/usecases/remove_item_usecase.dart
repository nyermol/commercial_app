import 'package:commercial_app/domain/repositories/list_repository.dart';

class RemoveItemUsecase {
  final ListRepository repository;

  RemoveItemUsecase(this.repository);

  Future<void> call(String key, int index) async {
    return repository.removeItem(key, index);
  }
}
