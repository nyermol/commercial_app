import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

void buildRemarksList(
  pw.Document pdf,
  pw.Font font,
  pw.Font boldFont,
  pw.Font italicFont,
  Uint8List eviLogoBytes,
  Uint8List dividerBytes,
  String orderNumber,
  String inspectionDate,
  String specialistName,
  String residence,
  String radiation,
  String ammonia,
  String electromagneticField,
  String airflowKitchen,
  String airflowSU1,
  String airflowSU2,
  String airflowSU3,
  Map<String, List<Remark>> remarksState,
) {
  final Map<String, String> categoryTitles = <String, String>{
    'electricsItems': 'ЭЛЕКТРИКА',
    'geometryItems': 'ГЕОМЕТРИЯ',
    'plumbingEquipmentItems': 'САНТЕХНИКА',
    'windowsAndDoorsItems': 'ОКНА И ДВЕРИ',
    'finishingItems': 'ОТДЕЛКА',
  };

  List<pw.Widget> remarkSections = <pw.Widget>[];

  categoryTitles.forEach((String key, String displayTitle) {
    final List<Remark> remarks = remarksState[key] ?? <Remark>[];
    if (remarks.isNotEmpty) {
      remarkSections.add(
        pw.Align(
          alignment: pw.Alignment.center,
          child: pw.Text(
            displayTitle,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 14,
              color: const PdfColor.fromInt(0xFF24555E),
            ),
          ),
        ),
      );
      remarkSections.add(pw.SizedBox(height: 10));
      for (int i = 0; i < remarks.length; i++) {
        remarkSections.add(
          pw.Container(
            margin: const pw.EdgeInsets.only(left: 20),
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: buildRemarkSection(
                i,
                remarks[i],
                boldFont,
                italicFont,
              ),
            ),
          ),
        );
      }
      remarkSections.add(pw.SizedBox(height: 10));
    }
  });

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
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
                'Список выявленных недостатков по заказу № $orderNumber',
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
            ...remarkSections,
            pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Измерения',
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
            buildMeasurements(
              context,
              boldFont,
              radiation,
              ammonia,
              electromagneticField,
              airflowKitchen,
              airflowSU1,
              airflowSU2,
              airflowSU3,
            ),
          ],
        ),
      ],
    ),
  );
}
