import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildSignatureBloc(
  pw.Font font,
  pw.Font italicFont,
  String customerName,
) {
  pw.Widget signatureField(
    double width,
    double height,
    PdfColor color,
    String text,
    pw.Font font,
    double fontSize,
  ) {
    return pw.Container(
      width: width,
      height: height,
      color: color,
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: fontSize,
        ),
      ),
    );
  }

  return pw.Row(
    children: <pw.Widget>[
      pw.Column(
        children: <pw.Widget>[
          signatureField(
            97,
            20,
            const PdfColor.fromInt(0xFFD0CECE),
            '',
            font,
            10,
          ),
          signatureField(
            97,
            10,
            PdfColors.white,
            'подпись клиента',
            italicFont,
            8,
          ),
        ],
      ),
      pw.SizedBox(width: 10),
      pw.Column(
        children: <pw.Widget>[
          signatureField(
            135,
            20,
            const PdfColor.fromInt(0xFFD0CECE),
            customerName,
            font,
            10,
          ),
          signatureField(
            135,
            10,
            PdfColors.white,
            'расшифровка',
            italicFont,
            8,
          ),
        ],
      ),
    ],
  );
}
