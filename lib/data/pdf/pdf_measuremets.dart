import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildMeasurements(
  pw.Context context,
  pw.Font boldFont,
  String radiation,
  String ammonia,
  String electromagneticField,
  String airflowKitchen,
  String airflowSU1,
  String airflowSU2,
  String airflowSU3,
) {
  pw.Widget measurementBloc(
    double width,
    PdfColor color,
    pw.AlignmentGeometry alignment,
    String text,
  ) {
    return pw.Container(
      height: 20,
      width: width,
      color: color,
      alignment: alignment,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: boldFont,
          fontSize: 8,
        ),
      ),
    );
  }

  return pw.Container(
    height: 45,
    width: 490,
    child: pw.Column(
      children: <pw.Widget>[
        pw.Row(
          children: <pw.Widget>[
            measurementBloc(
              55,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'Радиация:',
            ),
            measurementBloc(
              75,
              const PdfColor.fromInt(0xFFD0CECE),
              pw.Alignment.centerRight,
              '$radiation мк3в/ч  ',
            ),
            pw.SizedBox(width: 5),
            measurementBloc(
              70,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'Аммиак (NH3):',
            ),
            measurementBloc(
              75,
              const PdfColor.fromInt(0xFFD0CECE),
              pw.Alignment.centerRight,
              '$ammonia мг/м3  ',
            ),
            pw.SizedBox(width: 5),
            measurementBloc(
              130,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'ЭМП (Электромагнитное поле):',
            ),
            measurementBloc(
              75,
              const PdfColor.fromInt(0xFFD0CECE),
              pw.Alignment.centerRight,
              '$electromagneticField мкТл  ',
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          children: <pw.Widget>[
            measurementBloc(
              135,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'Скорость воздушного потока',
            ),
            measurementBloc(
              40,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'На кухне:',
            ),
            measurementBloc(
              45,
              const PdfColor.fromInt(0xFFD0CECE),
              pw.Alignment.centerRight,
              '$airflowKitchen м/с  ',
            ),
            pw.SizedBox(width: 5),
            measurementBloc(
              40,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'В с/у №1:',
            ),
            measurementBloc(
              45,
              const PdfColor.fromInt(0xFFD0CECE),
              pw.Alignment.centerRight,
              '$airflowSU1 м/с  ',
            ),
            pw.SizedBox(width: 5),
            measurementBloc(
              40,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'В с/у №2:',
            ),
            measurementBloc(
              45,
              const PdfColor.fromInt(0xFFD0CECE),
              pw.Alignment.centerRight,
              '$airflowSU2 м/с  ',
            ),
            pw.SizedBox(width: 5),
            measurementBloc(
              40,
              PdfColors.white,
              pw.Alignment.centerLeft,
              'В с/у №3:',
            ),
            measurementBloc(
              45,
              const PdfColor.fromInt(0xFFD0CECE),
              pw.Alignment.centerRight,
              '$airflowSU3 м/с  ',
            ),
          ],
        ),
      ],
    ),
  );
}
