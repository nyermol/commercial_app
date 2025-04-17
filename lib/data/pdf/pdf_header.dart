import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// Верхний колонтитул (зависит от четности страницы)
pw.Widget buildHeader(
  pw.Context context,
  Uint8List headerPhoto,
  pw.Font font,
  pw.Font italicFont,
  String orderNumber,
  String inspectionDate,
  String specialistName,
  String residence,
) {
  pw.Widget headerBloc(
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

  return pw.Container(
    child: pw.Row(
      children: <pw.Widget>[
        pw.Image(
          pw.MemoryImage(headerPhoto),
          width: 220,
        ),
        pw.SizedBox(width: 30),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Row(
              children: <pw.Widget>[
                pw.Column(
                  children: <pw.Widget>[
                    headerBloc(
                      110,
                      20,
                      const PdfColor.fromInt(0xFFD0CECE),
                      orderNumber,
                      font,
                      10,
                    ),
                    headerBloc(
                      110,
                      10,
                      PdfColors.white,
                      'номер заказа',
                      italicFont,
                      8,
                    ),
                  ],
                ),
                pw.SizedBox(width: 30),
                pw.Column(
                  children: <pw.Widget>[
                    headerBloc(
                      90,
                      20,
                      const PdfColor.fromInt(0xFFD0CECE),
                      inspectionDate,
                      font,
                      10,
                    ),
                    headerBloc(
                      90,
                      10,
                      PdfColors.white,
                      'дата осмотра',
                      italicFont,
                      8,
                    ),
                  ],
                ),
              ],
            ),
            pw.Column(
              children: <pw.Widget>[
                headerBloc(
                  230,
                  20,
                  const PdfColor.fromInt(0xFFD0CECE),
                  context.pageNumber % 2 == 0
                      ? specialistName
                      : 'ЖК $residence',
                  font,
                  10,
                ),
                headerBloc(
                  230,
                  10,
                  PdfColors.white,
                  context.pageNumber % 2 == 0
                      ? 'специалист'
                      : 'наименование ЖК',
                  italicFont,
                  8,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
