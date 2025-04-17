import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildParagraph(String text, pw.Font font, PdfColor textColor) {
  return pw.Paragraph(
    text: text,
    style: pw.TextStyle(
      font: font,
      fontSize: 10,
      lineSpacing: 5,
      color: textColor,
    ),
    textAlign: pw.TextAlign.justify,
  );
}
