// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:commercial_app/data/enums/enums_export.dart';

// Фабрика ссылок для скачивания PDF
typedef AnchorFactory = dynamic Function(
  String url,
);
typedef WindowOpenFn = void Function(
  String url,
  String target,
);

class DocumentService {
  final AnchorFactory createAnchor;
  final WindowOpenFn openWindow;

  DocumentService({
    AnchorFactory? createAnchor,
    WindowOpenFn? openWindow,
  })  : createAnchor =
            createAnchor ?? ((String url) => html.AnchorElement(href: url)),
        openWindow =
            openWindow ?? ((String url, String t) => html.window.open(url, t));

  void generateDocument({
    required String url,
    required String fileName,
    required DocumentDisplayMode mode,
  }) {
    if (mode == DocumentDisplayMode.download) {
      createAnchor(url)
        ..setAttribute('download', '$fileName.pdf')
        ..click();
    } else {
      openWindow(url, '_blank');
    }
  }
}
