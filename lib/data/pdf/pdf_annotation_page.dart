import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

void buildAnnotationPage(
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
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.center,
              child: textWidget('Аннотация', boldFont, 18),
            ),
            pw.SizedBox(height: 10),
            pw.Image(
              pw.MemoryImage(dividerBytes),
              width: 490,
            ),
            pw.SizedBox(height: 10),
            buildParagraph(
              '             Инструментальное обследование объекта произведено на основании договора на '
              'выполнение работ по проведению технического осмотра.\n'
              '             Работы по техническому осмотру строительно-отделочных работ проведены специалистами ООО'
              '«ЭВИ Приемочная компания» с целью получения объективных данных о техническом состоянии объекта, '
              'выявления возможных технологических, строительно-монтажных дефектов.',
              font,
              PdfColors.black,
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.center,
              child: textWidget('Основные сведения', boldFont, 18),
            ),
            pw.SizedBox(height: 10),
            pw.Image(
              pw.MemoryImage(dividerBytes),
              width: 490,
            ),
            pw.SizedBox(height: 10),
            buildParagraph(
              '             Работы по техническому осмотру строительно-отделочных работ проведены специалистами ООО'
              '«ЭВИ Приемочная компания» с целью получения объективных данных о техническом состоянии объекта, '
              'выявления возможных технологических, строительно-монтажных дефектов.\n'
              '             Для достижения цели инженерно-технического обследования экспертной организацией '
              'выполнен следующий комплекс работ:\n'
              '       1.  Проведение визуально-инструментального обследования объекта технического осмотра в '
              'границах обследуемого участка.\n'
              '       2.  Составление технического акта осмотра по выявленным дефектам.\n'
              '       3.  Обработка данных, полученных по результатам проведенного обследования.\n'
              '       4.  Составление технического заключения, содержащего:\n'
              '             — Результаты визуально-инструментального технического обследования;\n'
              '             — Описание выявленных нарушений и наличий дефектов согласно действующим нормам СП и ГОСТ.',
              font,
              PdfColors.black,
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.center,
              child:
                  textWidget('Сведения об экспертном учреждении', boldFont, 18),
            ),
            pw.SizedBox(height: 10),
            pw.Image(
              pw.MemoryImage(dividerBytes),
              width: 490,
            ),
            pw.SizedBox(height: 10),
            buildParagraph(
              'Юридический адрес: 195220, г. Санкт-Петербург, вн.тер.г. муниципальный округ '
              'Гражданка, пр-кт Гражданский, д. 26, литера А, часть пом. 13-Н, офис 5-8',
              font,
              PdfColors.black,
            ),
            textWidget('ИНН: 7804692146', font, 10),
            pw.SizedBox(height: 10),
            textWidget('КПП: 780401001', font, 10),
            pw.SizedBox(height: 10),
            textWidget('ОГРН: 1227800042645', font, 10),
            pw.SizedBox(height: 10),
            textWidget('Тел.: +7 (812) 985-85-15', font, 10),
            pw.SizedBox(height: 10),
            textWidget('info@evipriemka.ru', font, 10),
          ],
        ),
      ],
    ),
  );
}
