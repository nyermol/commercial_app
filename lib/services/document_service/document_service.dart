import 'package:flutter/material.dart';

import 'document_service_mobile.dart'
    if (dart.library.html) 'document_service_web.dart';

// Интерфейс для генерации и показа PDF
abstract class DocumentService {
  Future<void> generateAndDisplay(BuildContext context);
}

// Передача нужной реализации
DocumentService getDocumentService() => DocumentServiceImpl();
