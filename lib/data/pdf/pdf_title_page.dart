import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

void buildTitlePage(
  pw.Document pdf,
  pw.Font font,
  pw.Font boldFont,
  Uint8List titleImage,
  Uint8List smallDividerImage,
  String orderNumber,
  String inspectionDate,
  String customerName,
  String city,
) {
  pw.Widget textWidget(String text, pw.Font font, double fontSize) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        fontSize: fontSize,
      ),
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => <pw.Widget>[
        pw.Row(
          children: <pw.Widget>[
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Image(
                  pw.MemoryImage(titleImage),
                  width: 220,
                ),
                pw.SizedBox(height: 207),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    textWidget('Отчет\n№ $orderNumber', boldFont, 36),
                    textWidget('с осмотра объекта', boldFont, 20),
                  ],
                ),
                pw.SizedBox(height: 100),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Image(
                      pw.MemoryImage(smallDividerImage),
                      width: 300,
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      children: <pw.Widget>[
                        textWidget('Дата осмотра:', boldFont, 12),
                        pw.SizedBox(width: 30),
                        textWidget(inspectionDate, font, 12),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      children: <pw.Widget>[
                        textWidget('Дата составления отчета:', boldFont, 12),
                        pw.SizedBox(width: 30),
                        textWidget(inspectionDate, font, 12),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      children: <pw.Widget>[
                        textWidget('Заказчик:', boldFont, 12),
                        pw.SizedBox(width: 30),
                        textWidget(customerName, font, 12),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 100),
                textWidget(
                  '$city, 2025 г.\n© Все права на распространение и копирование данного\n'
                  'документа принадлежат ООО «ЭВИ Приемочная компания»',
                  font,
                  10,
                ),
              ],
            ),
            pw.SizedBox(width: 45),
            pw.Container(
              width: 170,
              height: 728,
              color: const PdfColor.fromInt(0xFFD0CECE),
              alignment: pw.Alignment.topCenter,
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(top: 15),
                child: textWidget(
                  'ООО «ЭВИ\nПриемочная компания»\n+7 (812) 985-85-15\ninfo@evipriemka.ru',
                  font,
                  12,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
