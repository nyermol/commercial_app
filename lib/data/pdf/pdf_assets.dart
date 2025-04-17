import 'package:flutter/services.dart';

class PdfAssets {
  final Uint8List eviLogo;
  final Uint8List smallDivider;
  final Uint8List divider;
  final Uint8List document0591R;
  final Uint8List document1951V;
  final Uint8List document0590R;
  final Uint8List erikDiplom;
  final Uint8List viktorDiplom;
  final Uint8List erikAssertment;
  final Uint8List viktorAssertment;
  final Uint8List oooDocument;
  final Uint8List qrCode;

  PdfAssets({
    required this.eviLogo,
    required this.smallDivider,
    required this.divider,
    required this.document0591R,
    required this.document1951V,
    required this.document0590R,
    required this.erikDiplom,
    required this.viktorDiplom,
    required this.erikAssertment,
    required this.viktorAssertment,
    required this.oooDocument,
    required this.qrCode,
  });
}

Future<PdfAssets> loadPdfAssets() async {
  // Определяем пути ко всем ассетам
  final Map<String, String> assetPaths = <String, String>{
    'eviLogo': 'assets/images/evi_logo.png',
    'smallDivider': 'assets/images/small_divider.png',
    'divider': 'assets/images/divider.png',
    'document0591R': 'assets/images/document_0591_R.png',
    'document1951V': 'assets/images/document_1951_V.png',
    'document0590R': 'assets/images/document_0590_R.png',
    'erikDiplom': 'assets/images/erik_diplom.png',
    'viktorDiplom': 'assets/images/viktor_diplom.png',
    'erikAssertment': 'assets/images/erik_assertment.png',
    'viktorAssertment': 'assets/images/viktor_assertment.png',
    'oooDocument': 'assets/images/ooo_document.png',
    'qrCode': 'assets/images/qr-code.png',
  };

  // Загружаем ассеты параллельно
  final Map<String, Future<ByteData>> futures = assetPaths
      // ignore: always_specify_types
      .map((String key, String path) => MapEntry(key, rootBundle.load(path)));
  final List<ByteData> results = await Future.wait(futures.values);

  return PdfAssets(
    eviLogo: results.elementAt(0).buffer.asUint8List(),
    smallDivider: results.elementAt(1).buffer.asUint8List(),
    divider: results.elementAt(2).buffer.asUint8List(),
    document0591R: results.elementAt(3).buffer.asUint8List(),
    document1951V: results.elementAt(4).buffer.asUint8List(),
    document0590R: results.elementAt(5).buffer.asUint8List(),
    erikDiplom: results.elementAt(6).buffer.asUint8List(),
    viktorDiplom: results.elementAt(7).buffer.asUint8List(),
    erikAssertment: results.elementAt(8).buffer.asUint8List(),
    viktorAssertment: results.elementAt(9).buffer.asUint8List(),
    oooDocument: results.elementAt(10).buffer.asUint8List(),
    qrCode: results.elementAt(11).buffer.asUint8List(),
  );
}
