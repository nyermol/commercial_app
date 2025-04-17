// ignore_for_file: avoid_web_libraries_in_flutter, always_specify_types

import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  final PdfConfig config;
  final pw.Document pdf;

  PdfGenerator({required this.config}) : pdf = pw.Document();

  Future<Uint8List> generatePdf(
    Map<String, dynamic> dataState,
    Map<String, List<Remark>> remarksState,
    Map<String, dynamic> buttonState,
    Function(double) updateProgress,
  ) async {
    updateProgress(0.08);
    // Титульная страница
    buildTitlePage(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.assets.eviLogo,
      config.assets.smallDivider,
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['customer_name'] ?? S.current.notSpecified}',
      '${dataState['city'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.16);
    // Страница с аннотациями
    buildAnnotationPage(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.24);
    // Страница со списком выявленных недостатков
    buildRemarksList(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
      '${dataState['radiation'] ?? 0}',
      '${dataState['ammonia'] ?? 0}',
      '${dataState['electromagneticField'] ?? 0}',
      '${dataState['airflowKitchen'] ?? 0}',
      '${dataState['airflowSU1'] ?? 0}',
      '${dataState['airflowSU2'] ?? 0}',
      '${dataState['airflowSU3'] ?? 0}',
      remarksState,
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.32);
    // Страница с подписями
    buildSignaturePage(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['customer_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
      buttonState['thermalImagingInspection'] as String,
      buttonState['thermalImagingConclusion'] as String,
      buttonState['underfloorHeating'] as String,
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.4);
    // Страницы с документами компании
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Проверки и калибровки на оборудование',
      pw.Image(
        pw.MemoryImage(config.assets.document0591R),
        height: 580,
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.48);
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Проверки и калибровки на оборудование',
      pw.Image(
        pw.MemoryImage(config.assets.document1951V),
        height: 580,
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.56);
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Проверки и калибровки на оборудование',
      pw.Image(
        pw.MemoryImage(config.assets.document0590R),
        height: 580,
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.64);
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Квалификация специалиста',
      pw.Image(
        pw.MemoryImage(config.assets.erikDiplom),
        width: 490,
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.72);
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Квалификация специалиста',
      pw.Image(
        pw.MemoryImage(config.assets.viktorDiplom),
        width: 490,
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.8);
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Квалификация специалиста',
      pw.Image(
        pw.MemoryImage(config.assets.erikAssertment),
        width: 490,
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.88);
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Квалификация специалиста',
      pw.Image(
        pw.MemoryImage(config.assets.viktorAssertment),
        width: 490,
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.96);
    buildPageWithDocuments(
      pdf,
      config.fonts.regular,
      config.fonts.bold,
      config.fonts.italic,
      config.assets.eviLogo,
      config.assets.divider,
      'Документы компании',
      pw.Column(
        children: <pw.Widget>[
          pw.Image(
            pw.MemoryImage(config.assets.oooDocument),
            height: 480,
          ),
          pw.Container(
            width: 490,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                buildParagraph(
                  'Благодарим вас за обращение в компанию «ЭВИ Приемочная компания»!\n'
                  'Если вы остались довольны приемкой – пожалуйста, оставьте отзыв о нашей\nработе '
                  'на площадках ЭВИ и в чате соседей.',
                  config.fonts.regular,
                  PdfColors.black,
                ),
                pw.Image(
                  pw.MemoryImage(config.assets.qrCode),
                  width: 100,
                ),
              ],
            ),
          ),
        ],
      ),
      '${dataState['order_number'] ?? S.current.notSpecified}',
      '${dataState['inspection_date'] ?? S.current.notSpecified}',
      '${dataState['specialist_name'] ?? S.current.notSpecified}',
      '${dataState['residence'] ?? S.current.notSpecified}',
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(1);
    // Сохранение PDF-файла
    return await pdf.save();
  }
}
