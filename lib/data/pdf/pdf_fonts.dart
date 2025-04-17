import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFonts {
  final pw.Font regular;
  final pw.Font bold;
  final pw.Font italic;

  PdfFonts({
    required this.regular,
    required this.bold,
    required this.italic,
  });
}

Future<PdfFonts> loadPdfFonts() async {
  final List<ByteData> results = await Future.wait(<Future<ByteData>>[
    rootBundle.load('assets/fonts/Arial-Regular.ttf'),
    rootBundle.load('assets/fonts/Arial-Bold.ttf'),
    rootBundle.load('assets/fonts/Arial-Italic.ttf'),
  ]);
  return PdfFonts(
    regular: pw.Font.ttf(results[0]),
    bold: pw.Font.ttf(results[1]),
    italic: pw.Font.ttf(results[2]),
  );
}
