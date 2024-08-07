import 'package:commercial_app/domain/repositories/data_repository.dart';

class LoadListUsecase {
  final DataRepository repository;

  LoadListUsecase({required this.repository});

  Future<List<String?>> call(String key) {
    return repository.loadList(key);
  }
}
