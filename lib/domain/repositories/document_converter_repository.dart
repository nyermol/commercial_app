abstract class DocumentConverterRepository {
  Future<String?> convertDocxToPdf(
    List<int> docxBytes,
    String fileName,
  );
}
