import 'package:commercial_app/data/models/models_export.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildRemarkSection(
  int index,
  Remark remark,
  pw.Font boldFont,
  pw.Font italicFont,
) {
  Uint8List loadImageBytes(String imageKey) {
    final Box<Uint8List> imagesBox = Hive.box<Uint8List>('imagesBox');
    final Uint8List? data = imagesBox.get(imageKey);
    if (data == null) {
      throw Exception('Image not found for key: $imageKey');
    }
    return data;
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: <pw.Widget>[
      pw.RichText(
        text: pw.TextSpan(
          text: '${index + 1}. ${remark.title}',
          style: pw.TextStyle(
            font: boldFont,
            fontSize: 12,
            color: PdfColors.black,
          ),
          children: remark.subtitle.trim().isNotEmpty
              ? <pw.InlineSpan>[
                  pw.TextSpan(
                    text: ' (${remark.subtitle})',
                    style: const pw.TextStyle(
                      color: PdfColor.fromInt(0xFF24555E),
                    ),
                  ),
                ]
              : <pw.InlineSpan>[],
        ),
      ),
      pw.Text(
        remark.gost,
        style: pw.TextStyle(
          font: italicFont,
          fontSize: 12,
          color: const PdfColor.fromInt(0xFFD0CECE),
        ),
      ),
      if (remark.images.isNotEmpty)
        pw.Wrap(
          spacing: 5,
          runSpacing: 5,
          children: remark.images.map((String imageKey) {
            final Uint8List imageData = loadImageBytes(imageKey);
            return pw.Container(
              width: 100,
              height: 100,
              child: pw.Image(
                pw.MemoryImage(imageData),
                fit: pw.BoxFit.cover,
              ),
            );
          }).toList(),
        ),
      pw.SizedBox(height: 10),
    ],
  );
}
