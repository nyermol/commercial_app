// ignore_for_file: avoid_web_libraries_in_flutter, always_specify_types, use_build_context_synchronously

import 'dart:html' as html;
import 'dart:typed_data';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
      final PdfAssets assets = await loadPdfAssets();
      final PdfFonts fonts = await loadPdfFonts();
      final PdfGenerator generator = PdfGenerator(
        config: PdfConfig(
          assets: assets,
          fonts: fonts,
        ),
      );
      final Uint8List pdfBytes = await generator.generatePdf(
        _dataCubit.state,
        _remarksCubit.state,
        _buttonCubit.state,
        (double newProgress) =>
            progressKey.currentState?.updateProgress(newProgress),
      );
      final html.Blob blob = html.Blob([pdfBytes], 'application/pdf');
      final String url = html.Url.createObjectUrlFromBlob(blob);
      Navigator.of(context).pop();
      showCustomDialog(
        context: context,
        title: S.of(context).chooseDisplayDocument,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                S.of(context).downloadDocument,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mainFontSize,
                  color: mainColor,
                ),
              ),
              onTap: () {
                html.AnchorElement(href: url)
                  ..setAttribute('download', 'document.pdf')
                  ..click();
                html.Url.revokeObjectUrl(url);
                Navigator.of(context).pop();
                showCustomDialog(
                  context: context,
                  title: S.of(context).pdfSuccessfullyOpened,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        S.of(context).iosDisplayAbstract,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: remarksFontSize,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.03,
                      ),
                      Text(
                        S.of(context).androidDisplayAbstract,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: remarksFontSize,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.03,
                      ),
                      Text(
                        S.of(context).externalDisplayAbstract,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: remarksFontSize,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        S.of(context).back,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            ListTile(
              title: Text(
                S.of(context).openDocumentWindow,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: mainFontSize,
                  color: mainColor,
                ),
              ),
              onTap: () {
                html.window.open(url, '_blank');
                html.Url.revokeObjectUrl(url);
                Navigator.of(context).pop();
                showCustomDialog(
                  context: context,
                  title: S.of(context).pdfSuccessfullyOpened,
                  content: Text(
                    S.of(context).documentOpenWindowAbstract,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: remarksFontSize,
                      color: Colors.grey,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        S.of(context).back,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
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
        actions: <Widget>[
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
