import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

void buildPageWithDocuments(
  pw.Document pdf,
  pw.Font font,
  pw.Font boldFont,
  pw.Font italicFont,
  Uint8List eviLogoBytes,
  Uint8List dividerBytes,
  String titleText,
  pw.Widget photoWidget,
  String orderNumber,
  String inspectionDate,
  String specialistName,
  String residence,
) {
  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(base: font),
      header: (pw.Context context) => buildHeader(
        context,
        eviLogoBytes,
        font,
        italicFont,
        orderNumber,
        inspectionDate,
        specialistName,
        residence,
      ),
      footer: (pw.Context context) => buildFooter(
        context,
        dividerBytes,
        boldFont,
      ),
      build: (pw.Context context) => <pw.Widget>[
        pw.Column(
          children: <pw.Widget>[
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                titleText,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 18,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Image(
              pw.MemoryImage(dividerBytes),
              width: 490,
            ),
            pw.SizedBox(height: 10),
            photoWidget,
          ],
        ),
      ],
    ),
  );
}
