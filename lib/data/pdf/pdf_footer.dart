import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

// Нижний колонтитул (нумерация страниц)
pw.Widget buildFooter(
  pw.Context context,
  Uint8List footerDivider,
  pw.Font boldFont,
) {
  pw.Widget textWidget(pw.TextAlign align, String text) {
    return pw.Text(
      textAlign: align,
      text,
      style: pw.TextStyle(
        font: boldFont,
        fontSize: 10,
      ),
    );
  }

  return pw.Container(
    child: pw.Column(
      children: <pw.Widget>[
        pw.Image(
          pw.MemoryImage(footerDivider),
          width: 490,
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: <pw.Widget>[
            textWidget(
              pw.TextAlign.left,
              'Страница ${context.pageNumber} из ${context.pagesCount}',
            ),
            textWidget(
              pw.TextAlign.right,
              '+7 (812) 985-85-15\ninfo@evipriemka.ru',
            ),
          ],
        ),
      ],
    ),
  );
}
