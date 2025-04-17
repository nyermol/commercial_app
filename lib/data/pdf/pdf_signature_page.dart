import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

void buildSignaturePage(
  pw.Document pdf,
  pw.Font font,
  pw.Font boldFont,
  pw.Font italicFont,
  Uint8List eviLogoBytes,
  Uint8List dividerBytes,
  String orderNumber,
  String inspectionDate,
  String specialistName,
  String customerName,
  String residence,
  String thermalImagingInspection,
  String thermalImagingConclusion,
  String underfloorHeating,
) {
  pw.Widget textWidget(String text, pw.Font font) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        fontSize: 10,
      ),
    );
  }

  pw.Widget richTextWidget(String firstText, List<pw.TextSpan> items) {
    return pw.RichText(
      textAlign: pw.TextAlign.justify,
      text: pw.TextSpan(
        text: firstText,
        style: pw.TextStyle(
          font: boldFont,
          fontSize: 8,
        ),
        children: items,
      ),
    );
  }

  pw.Widget signatureRow(pw.Widget widget) {
    return pw.Row(
      children: <pw.Widget>[
        pw.Container(
          width: 240,
          child: widget,
        ),
        buildSignatureBloc(
          font,
          italicFont,
          customerName,
        ),
      ],
    );
  }

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
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.SizedBox(height: 10),
            buildParagraph(
              '             Обращаем ваше внимание на то, что данный отчет является лишь перечнем выявленных '
              'недостатков и не является официальным документом. Все выявленные недостатки, которые подлежат '
              'исправлению, необходимо обязательно отразить в официальном акте осмотра (дефектной ведомости) застройщика!',
              italicFont,
              PdfColors.red,
            ),
            pw.Container(
              height: 220,
              width: 490,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  signatureRow(
                    textWidget('  С выявленными замечаниями ознакомлен:', font),
                  ),
                  pw.SizedBox(height: 10),
                  textWidget(
                    '  Проводился ли тепловизионный осмотр (услуга оплачивается отдельно):',
                    font,
                  ),
                  pw.SizedBox(height: 10),
                  signatureRow(
                    buildButtonRow(thermalImagingInspection),
                  ),
                  pw.SizedBox(height: 10),
                  textWidget(
                    '  Требуется ли заключение по тепловизионному осмотру (услуга оплачивается отдельно):',
                    font,
                  ),
                  pw.SizedBox(height: 10),
                  signatureRow(
                    buildButtonRow(thermalImagingConclusion),
                  ),
                  pw.SizedBox(height: 10),
                  textWidget(
                    '  Проводилась ли проверка тёплого пола тепловизором (услуга оплачивается отдельно):',
                    font,
                  ),
                  pw.SizedBox(height: 10),
                  signatureRow(
                    buildButtonRow(underfloorHeating),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            textWidget('Сроки выполнения прочих услуг:', boldFont),
            pw.SizedBox(height: 5),
            richTextWidget(
              'Отчёт об оценке:',
              <pw.TextSpan>[
                pw.TextSpan(
                  text:
                      ' до 3 рабочих дней при индивидуальном заказе и до 5 при коллективном. Начиная с '
                      'даты предоставления всех необходимых документов. По готовности отчёта Вам позвонит менеджер '
                      'и договорится о доставке.',
                  style: pw.TextStyle(
                    font: font,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            richTextWidget(
              'Официальная проверка площади с составлением подробного плана квартиры:',
              <pw.TextSpan>[
                pw.TextSpan(
                  text:
                      ' до 5 рабочих дней, при наличии дополнительных размеров (отдельно оплачиваемые '
                      'расширения) срок может быть увеличен до 7 рабочих дней. Готовый план будет отправлен '
                      'Вам на электронную почту. ',
                  style: pw.TextStyle(
                    font: font,
                  ),
                ),
                pw.TextSpan(
                  text:
                      'Заключение кадастрового инженера оплачивается отдельно',
                  style: pw.TextStyle(
                    font: boldFont,
                  ),
                ),
                pw.TextSpan(
                  text: ', подготовка заключения до 5 рабочих дней.',
                  style: pw.TextStyle(
                    font: font,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            richTextWidget(
              'Термографический отчёт (осмотр тепловизором):',
              <pw.TextSpan>[
                pw.TextSpan(
                  text:
                      ' до 5 календарных дней. Отчёт будет отправлен Вам на электронную почту.',
                  style: pw.TextStyle(
                    font: font,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            richTextWidget(
              'Заключение специалиста:',
              <pw.TextSpan>[
                pw.TextSpan(
                  text:
                      ' до 5 календарных дней. Заключение отправляется Вам на электронную почту. Печатную '
                      'версию отчета можно получить в офисе компании «ЭВИ».',
                  style: pw.TextStyle(
                    font: font,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Обязательства застройщика перед участником долевого строительства:',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 10,
                color: PdfColors.red,
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              '       1.  Застройщик обязан передать участнику долевого строительства объект долевого строительства, '
              'качество которого соответствует условиям договора, требованиям технических регламентов, проектной '
              'документации и градостроительных регламентов, а также иным обязательным требованиям. (в ред. Федерального'
              'закона от 18.07.2006 N 111-Ф3).\n'
              '       2.  В случае, если объект долевого строительства построен (создан) застройщиком с отступлениями '
              'от условий договора и (или) указанных в п.1 обязательных требований, приведшими к ухудшению качества '
              'такого объекта, или с иными недостатками, которые делают его непригодным для предусмотренного договором '
              'использования, участник долевого строительства, если иное не установлено договором, по своему выбору вправе '
              'потребовать от застройщика (в ред. Федерального закона от 18.07.2006 N 111-Ф3):\n'
              '             – безвозмездного устранения недостатков в разумный срок;\n'
              '             – соразмерного уменьшения цены договора;\n'
              '             – – возмещения своих расходов на устранение недостатков.\n'
              '       3.  Гарантийный срок для объекта долевого строительства, за исключением технологического и инженерного '
              'оборудования, входящего в состав такого объекта долевого строительства, устанавливается договором и не может '
              'составлять менее чем пять лет. Гарантийный срок на технологическое и инженерное оборудование, входящее в состав '
              'передаваемого участникам долевого строительства объекта долевого строительства, устанавливается договором и '
              'не может составлять менее чем три года. Указанный гарантийный срок исчисляется со дня передачи объекта долевого '
              'строительства, за исключением технологического и инженерного оборудования, входящего в состав такого объекта '
              'долевого строительства, участнику долевого строительства, если иное не предусмотрено договором. (в ред. Федерального '
              'закона от 17.06.2010 N 119-Ф3).',
              textAlign: pw.TextAlign.justify,
              style: const pw.TextStyle(
                fontSize: 8,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
