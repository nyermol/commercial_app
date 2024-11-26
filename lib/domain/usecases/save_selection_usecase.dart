import 'package:commercial_app/domain/repositories/option_repository.dart';

class SaveSelectionUsecase {
  final OptionRepository repository;

  SaveSelectionUsecase(this.repository);

  Future<void> call(String key, String value) {
    return repository.saveSelection(key, value);
  }
}
