import 'package:commercial_app/domain/repositories/data_repository.dart';

class SaveListUsecase {
  final DataRepository repository;

  SaveListUsecase({required this.repository});
  Future<void> call(String key, List<String> list) {
    return repository.saveList(key, list);
  }
}
