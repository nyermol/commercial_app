import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildButtonRow(String selected) {
  final bool isYes = selected.trim().toLowerCase() == 'да';
  final PdfColor yesColor =
      isYes ? const PdfColor.fromInt(0xFF24555E) : PdfColors.white;
  final PdfColor noColor =
      isYes ? PdfColors.white : const PdfColor.fromInt(0xFF24555E);
  pw.Widget textWidget(String text) {
    return pw.Text(
      text,
      style: const pw.TextStyle(
        fontSize: 10,
      ),
    );
  }

  pw.Widget buildButton(PdfColor color) {
    return pw.Container(
      height: 20,
      width: 20,
      decoration: pw.BoxDecoration(
        color: color,
        border: pw.Border.all(
          width: 2,
          color: const PdfColor.fromInt(0xFF24555E),
        ),
      ),
    );
  }

  return pw.Row(
    children: <pw.Widget>[
      buildButton(yesColor),
      pw.SizedBox(width: 10),
      textWidget('Да'),
      pw.SizedBox(width: 40),
      buildButton(noColor),
      pw.SizedBox(width: 10),
      textWidget('Нет'),
    ],
  );
}
