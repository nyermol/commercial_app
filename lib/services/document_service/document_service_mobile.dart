// ignore_for_file: always_specify_types, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'document_service.dart';

class DocumentServiceImpl implements DocumentService {
  final DataCubit _dataCubit = GetIt.I<DataCubit>();
  final RemarksCubit _remarksCubit = GetIt.I<RemarksCubit>();
  final ButtonCubit _buttonCubit = GetIt.I<ButtonCubit>();

  @override
  Future<void> generateAndDisplay(BuildContext context) async {
    final GlobalKey<ProgressDialogState> progressKey =
        GlobalKey<ProgressDialogState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProgressDialog(
        key: progressKey,
        message: S.of(context).actFormWait,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      // Генерация PDF
      final PdfAssets assets = await loadPdfAssets();
      final PdfFonts fonts = await loadPdfFonts();
      final PdfGenerator generator =
          PdfGenerator(config: PdfConfig(assets: assets, fonts: fonts));
      final Uint8List pdfBytes = await generator.generatePdf(
        _dataCubit.state,
        _remarksCubit.state,
        _buttonCubit.state,
        (double newProgress) =>
            progressKey.currentState?.updateProgress(newProgress),
      );
      // Сохранить во временный файл
      final String fileName =
          '№${_dataCubit.state['order_number'] ?? S.current.notSpecified} (${_dataCubit.state['inspection_date'] ?? S.current.notSpecified})';
      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$fileName.pdf');
      await file.writeAsBytes(pdfBytes);
      Navigator.of(context).pop();
      final OpenResult result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        throw Exception('${result.type}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      showCustomDialog(
        context: context,
        title: S.of(context).errorDocumentGeneration,
        content: Text(
          e.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: mainFontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              S.of(context).ok,
              style: TextStyle(
                fontSize: mainFontSize,
                color: mainColor,
              ),
            ),
          ),
        ],
      );
    }
  }
}
