// ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously, always_specify_types, avoid_print

import 'package:commercial_app/data/enums/enums_export.dart';
import 'package:commercial_app/data/pdf/pdf_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/preview/components/preview_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;

class PreviewScreenBody extends StatefulWidget {
  const PreviewScreenBody({super.key});

  @override
  State<PreviewScreenBody> createState() => _PreviewScreenBodyState();
}

class _PreviewScreenBodyState extends State<PreviewScreenBody> {
  void _showFormatSelectionDialog() {
    showCustomDialog(
      context: context,
      title: S.of(context).chooseDisplayDocument,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
              await _generateDocument(
                DocumentDisplayMode.download,
                Column(
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
              );
            },
            child: Text(
              S.of(context).downloadDocument,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: mainFontSize,
                color: mainColor,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.03,
          ),
          GestureDetector(
            onTap: () async {
              Navigator.of(context).pop();
              await _generateDocument(
                DocumentDisplayMode.openNewWindow,
                Text(
                  S.of(context).documentOpenWindowAbstract,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: remarksFontSize,
                    color: Colors.grey,
                  ),
                ),
              );
            },
            child: Text(
              S.of(context).openDocumentWindow,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: mainFontSize,
                color: mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateDocument(
    DocumentDisplayMode mode,
    Widget dialogContent,
  ) async {
    final dataCubit = context.read<DataCubit>();
    final remarksCubit = context.read<RemarksCubit>();
    final buttonCubit = context.read<ButtonCubit>();
    final GlobalKey<ProgressDialogState> progressKey =
        GlobalKey<ProgressDialogState>();
    // Показ диалога с индикатором прогресса
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => ProgressDialog(
        key: progressKey,
        message: S.of(context).actFormWait,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      // Генерация PDF документа
      final assets = await loadPdfAssets();
      final fonts = await loadPdfFonts();
      final config = PdfConfig(assets: assets, fonts: fonts);
      final pdfGenerator = PdfGenerator(config: config);
      final pdfBytes = await pdfGenerator.generatePdf(
        dataCubit.state,
        remarksCubit.state,
        buttonCubit.state,
        (double newProgress) =>
            progressKey.currentState?.updateProgress(newProgress),
      );

      final String fileName =
          '№${dataCubit.state['order_number'] ?? S.current.notSpecified} (${dataCubit.state['inspection_date'] ?? S.current.notSpecified})';
      // Создание Blob и получение URL
      final html.Blob blob = html.Blob([pdfBytes], 'application/pdf');
      final String url = html.Url.createObjectUrlFromBlob(blob);
      // Выбор способа отображения документа
      if (mode == DocumentDisplayMode.download) {
        html.AnchorElement(href: url)
          ..setAttribute('download', '$fileName.pdf')
          ..click();
      } else {
        html.window.open(url, '_blank');
      }
      html.Url.revokeObjectUrl(url);
      Navigator.of(context).pop();
      showCustomDialog(
        context: context,
        title: S.of(context).pdfSuccessfullyOpened,
        content: dialogContent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showFormatSelectionDialog();
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
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: false,
            thickness: 3,
            radius: const Radius.circular(3),
            child: ListView(
              padding: getHorizontalPadding(context, 0.03),
              children: [
                const OrderDisplay(),
                const RemarksDisplay(),
                MeasurementsDisplay(
                  title: S.of(context).additionalOptions,
                  labels: [
                    S.of(context).radiationLevel,
                    S.of(context).ammoniaLevel,
                    S.of(context).electromagneticFieldLevel,
                  ],
                  measurementKeys: const [
                    'radiation',
                    'ammonia',
                    'electromagneticField',
                  ],
                  units: [
                    S.of(context).radiationSI,
                    S.of(context).ammoniaSI,
                    S.of(context).electromagneticFieldSI,
                  ],
                ),
                MeasurementsDisplay(
                  title: S.of(context).airflowSpeed,
                  labels: [
                    S.of(context).airflowKitchen,
                    S.of(context).bath1,
                    S.of(context).bath2,
                    S.of(context).bath3,
                  ],
                  measurementKeys: const [
                    'airflowKitchen',
                    'airflowSU1',
                    'airflowSU2',
                    'airflowSU3',
                  ],
                  units: [
                    S.of(context).airflowSI,
                    S.of(context).airflowSI,
                    S.of(context).airflowSI,
                    S.of(context).airflowSI,
                  ],
                ),
                const OptionsDisplay(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            primaryPadding,
            primaryPadding,
            primaryPadding,
            primaryPadding * 2,
          ),
          child: SizedBox(
            width: SizeConfig.screenWidth * 0.75,
            child: DefaultButton(
              text: S.of(context).actForm,
              onPressed: _showFormatSelectionDialog,
            ),
          ),
        ),
      ],
    );
  }
}
