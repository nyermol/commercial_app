import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';

class GenerateDocumentUsecase {
  final DocumentGeneratorRepository repository;

  GenerateDocumentUsecase(this.repository);

  Future<void> call(
    Map<String, dynamic> dataState,
    Map<String, List<Remark>> remarksState,
    Map<String, dynamic> buttonState,
  ) async {
    await repository.generateDocument(
      dataState,
      remarksState,
      buttonState,
    );
  }
}
