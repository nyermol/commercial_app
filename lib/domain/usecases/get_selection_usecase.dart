import 'package:commercial_app/domain/repositories/option_repository.dart';

class GetSelectionUsecase {
  final OptionRepository repository;

  GetSelectionUsecase(this.repository);

  Future<String> call(String key) {
    return repository.getSelection(key);
  }
}
