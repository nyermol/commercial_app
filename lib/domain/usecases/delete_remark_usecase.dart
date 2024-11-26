import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';

class DeleteRemarkUsecase {
  final RemarksRepository repository;

  DeleteRemarkUsecase(this.repository);

  Future<void> call(String key, int index) async {
    await repository.deleteRemark(key, index);
  }
}
