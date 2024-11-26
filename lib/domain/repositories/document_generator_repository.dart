import 'package:commercial_app/data/models/models_export.dart';

abstract class DocumentGeneratorRepository {
  Future<void> generateDocument(
    Map<String, dynamic> dataState,
    Map<String, List<Remark>> remarksState,
    Map<String, dynamic> buttonState,
  );
}
