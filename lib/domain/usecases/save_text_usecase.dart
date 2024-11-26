import 'package:commercial_app/domain/repositories/data_repository.dart';

class SaveTextUsecase {
  final DataRepository repository;

  SaveTextUsecase({required this.repository});
  Future<void> call(String key, String text) {
    return repository.saveText(key, text);
  }
}
