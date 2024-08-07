import 'package:commercial_app/domain/repositories/list_repository.dart';

class RemoveImageUsecase {
  final ListRepository repository;

  RemoveImageUsecase(this.repository);

  Future<void> call(String key, int itemIndex, String imagePath) async {
    return repository.removeImage(key, itemIndex, imagePath);
  }
}
