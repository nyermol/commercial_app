// ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously, always_specify_types

import 'dart:html' as html;
import 'package:commercial_app/data/errors/api_error.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/preview/components/preview_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

class PreviewScreenBody extends StatefulWidget {
  const PreviewScreenBody({super.key});

  @override
  State<PreviewScreenBody> createState() => _PreviewScreenBodyState();
}

class _PreviewScreenBodyState extends State<PreviewScreenBody> {
  // Метод сохранения документа в формате DOCX при ошибке 402 при конвертации
  void _saveDocx(
    Map<String, dynamic> dataState,
  ) async {
    try {
      final String fileName =
          '№${dataState['order_number'] ?? S.current.notSpecified} (${dataState['inspection_date'] ?? S.current.notSpecified})';
      final Box<List<int>> documentsBox = Hive.box<List<int>>('documentsBox');
      final List<int>? docBytes = documentsBox.get(fileName);
      if (docBytes != null) {
        html.AnchorElement(
          href: html.Url.createObjectUrlFromBlob(html.Blob([docBytes])),
        )
          ..setAttribute('download', '$fileName.docx')
          ..click();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error in _saveDocx: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DataCubit dataCubit = context.read<DataCubit>();
    final RemarksCubit remarksCubit = context.read<RemarksCubit>();
    final ButtonCubit buttonCubit = context.read<ButtonCubit>();

    return Column(
      children: <Widget>[
        Expanded(
          child: Scrollbar(
            thumbVisibility: false,
            thickness: 3,
            radius: const Radius.circular(3),
            child: ListView(
              primary: true,
              children: <Widget>[
                Padding(
                  padding: getHorizontalPadding(context, 0.03),
                  child: Column(
                    children: <Widget>[
                      const OrderDisplay(),
                      const RemarksDisplay(),
                      MeasurementsDisplay(
                        title: S.of(context).additionalOptions,
                        labels: <String>[
                          S.of(context).radiationLevel,
                          S.of(context).ammoniaLevel,
                          S.of(context).electromagneticFieldLevel,
                        ],
                        measurementKeys: const <String>[
                          'radiation',
                          'ammonia',
                          'electromagneticField',
                        ],
                        units: <String>[
                          S.of(context).radiationSI,
                          S.of(context).ammoniaSI,
                          S.of(context).electromagneticFieldSI,
                        ],
                      ),
                      MeasurementsDisplay(
                        title: S.of(context).airflowSpeed,
                        labels: <String>[
                          S.of(context).airflowKitchen,
                          S.of(context).bath1,
                          S.of(context).bath2,
                          S.of(context).bath3,
                        ],
                        measurementKeys: const <String>[
                          'airflowKitchen',
                          'airflowSU1',
                          'airflowSU2',
                          'airflowSU3',
                        ],
                        units: <String>[
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
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(primaryPadding),
          child: SizedBox(
            width: SizeConfig.screenWidth * 0.75,
            child: DefaultButton(
              text: S.of(context).actForm,
              onPressed: () async {
                showCustomDialog(
                  context: context,
                  title: '',
                  barrierDismissible: false,
                  content: SizedBox(
                    height: SizeConfig.screenHeight * 0.12,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).actFormWait,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),
                          const CircularProgressIndicator(
                            color: Color(0xFF24555E),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                try {
                  // Генерация и конвертация документа
                  final GenerateDocumentUsecase generateDocumentUseCase =
                      GetIt.instance<GenerateDocumentUsecase>();
                  await generateDocumentUseCase(
                    dataCubit.state,
                    remarksCubit.state,
                    buttonCubit.state,
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  // ignore: avoid_print
                  print('Error in showCustomDialog: $e');
                  Navigator.of(context).pop();
                  final String errorMessage =
                      (e is ApiError) ? e.message : S.of(context).unknownError;
                  showCustomDialog(
                    context: context,
                    title: S.of(context).conversionError,
                    content: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                    ),
                    // Если сервер вернул ошибку, то высвечивается диалоговое окно с возможностью сохранения документа в формате DOCX
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          S.of(context).saveDocx,
                          style: const TextStyle(
                            fontSize: mainFontSize,
                            color: Color(0xFF24555E),
                          ),
                        ),
                        onPressed: () {
                          _saveDocx(
                            dataCubit.state,
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          S.of(context).close,
                          style: const TextStyle(
                            fontSize: mainFontSize,
                            color: Color(0xFF24555E),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
