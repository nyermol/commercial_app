// ignore_for_file: always_specify_types, use_build_context_synchronously

import 'dart:io';

import 'package:commercial_app/core/utils/size_config.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/preview/components/preview_export.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

class PreviewScreenBody extends StatefulWidget {
  const PreviewScreenBody({super.key});

  @override
  State<PreviewScreenBody> createState() => _PreviewScreenBodyState();
}

class _PreviewScreenBodyState extends State<PreviewScreenBody> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _onCreateDocument(
    Map<String, dynamic> dataState,
    Map<String, dynamic> listState,
    Map<String, dynamic> buttonState,
  ) async {
    final ByteData data =
        await rootBundle.load('assets/templates/shablon.docx');
    final Uint8List bytes = data.buffer.asUint8List();
    final DocxTemplate docx = await DocxTemplate.fromBytes(bytes);
    String checkValue(dynamic value) {
      if (value == null || value == '') {
        return '0';
      }
      return value.toString();
    }

    final Content content = Content();
    content
      ..add(
        TextContent(
          'orderNumber',
          dataState['order_number'] ?? S.of(context).notSpecified,
        ),
      )
      ..add(
        TextContent(
          'inspectionDate',
          dataState['inspection_date'] ?? S.of(context).notSpecified,
        ),
      )
      ..add(
        TextContent(
          'specialistName',
          dataState['specialist_name'] ?? S.of(context).notSpecified,
        ),
      )
      ..add(
        TextContent(
          'customerName',
          dataState['customer_name'] ?? S.of(context).notSpecified,
        ),
      )
      ..add(TextContent('radiation', checkValue(dataState['radiation'])))
      ..add(TextContent('ammonia', checkValue(dataState['ammonia'])))
      ..add(
        TextContent(
          'electromagneticField',
          checkValue(dataState['electromagneticField']),
        ),
      )
      ..add(
        TextContent(
          'airflowKitchen',
          checkValue(dataState['airflowKitchen']),
        ),
      )
      ..add(TextContent('airflowSU1', checkValue(dataState['airflowSU1'])))
      ..add(TextContent('airflowSU2', checkValue(dataState['airflowSU2'])))
      ..add(TextContent('airflowSU3', checkValue(dataState['airflowSU3'])))
      ..add(
        ListContent(
          'electricsItems',
          _createItemsContent(listState['electricsItems']),
        ),
      )
      ..add(
        ListContent(
          'geometryItems',
          _createItemsContent(listState['geometryItems']),
        ),
      )
      ..add(
        ListContent(
          'plumbingEquipmentItems',
          _createItemsContent(listState['plumbingEquipmentItems']),
        ),
      )
      ..add(
        ListContent(
          'windowsAndDoorsItems',
          _createItemsContent(listState['windowsAndDoorsItems']),
        ),
      )
      ..add(
        ListContent(
          'finishingItems',
          _createItemsContent(listState['finishingItems']),
        ),
      );
    buttonState.forEach((String key, value) {
      if (value == S.of(context).yes) {
        if (key == 'thermalImagingInspection') {
          content
            ..add(TextContent('yestII', '■'))
            ..add(TextContent('notII', '□'));
        } else if (key == 'thermalImagingConclusion') {
          content
            ..add(TextContent('yestIU', '■'))
            ..add(TextContent('notIU', '□'));
        } else if (key == 'underfloorHeating') {
          content
            ..add(TextContent('yesuH', '■'))
            ..add(TextContent('nouH', '□'));
        }
      } else {
        if (key == 'thermalImagingInspection') {
          content
            ..add(TextContent('yestII', '□'))
            ..add(TextContent('notII', '■'));
        } else if (key == 'thermalImagingConclusion') {
          content
            ..add(TextContent('yestIU', '□'))
            ..add(TextContent('notIU', '■'));
        } else if (key == 'underfloorHeating') {
          content
            ..add(TextContent('yesuH', '□'))
            ..add(TextContent('nouH', '■'));
        }
      }
    });
    final List<int>? doc = await docx.generate(content);
    if (doc != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final order = dataState['order_number'] ?? S.of(context).notSpecified;
      final inspData =
          dataState['inspection_date'] ?? S.of(context).notSpecified;
      final String filePath = '${directory.path}/№$order ($inspData).docx';
      final File file = File(filePath);
      await file.writeAsBytes(doc);

      final result = await OpenFile.open(filePath);
      if (kDebugMode) {
        print(result.message);
      }
    } else {
      if (kDebugMode) {
        print(S.of(context).generatingError);
      }
    }
  }

  List<Content> _createItemsContent(List<Map<String, dynamic>>? items) {
    if (items == null) return <Content>[];
    return items
        .asMap()
        .entries
        .map((MapEntry<int, Map<String, dynamic>> entry) {
      int index = entry.key + 1;
      Map<String, dynamic> item = entry.value;
      String titleText = "$index. ${item['title']}";
      TextContent content = TextContent('title', titleText);
      String subtitleText = item['subtitle']?.trim().isEmpty ?? true
          ? ''
          : "(${item['subtitle']})";
      content.add(TextContent('subtitle', subtitleText));
      String gostText =
          item['gost']?.trim().isEmpty ?? true ? '' : "${item['gost']}";
      content.add(TextContent('gost', gostText));
      if (item['images'] != null && (item['images'] as List).isNotEmpty) {
        List<String> images = List<String>.from(item['images']);
        List<Content> imageContents = images.map((String imagePath) {
          final Uint8List imageBytes = File(imagePath).readAsBytesSync();
          final img.Image? originalImage = img.decodeImage(imageBytes);
          final img.Image correctedImage = img.bakeOrientation(originalImage!);
          final Uint8List processedBytes = img.encodeJpg(correctedImage);

          return ImageContent('image', processedBytes);
        }).toList();
        content.add(ListContent('images', imageContents));
      }
      return content;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: getHorizontalPadding(context, 0.03),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
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
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.01),
            child: SizedBox(
              width: SizeConfig.screenWidth * 0.75,
              child: DefaultButton(
                text: S.of(context).actForm,
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return PlatformAlertDialog(
                        content: SizedBox(
                          height: SizeConfig.screenHeight * 0.12,
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
                              const CircularProgressIndicator.adaptive(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  final DataCubit dataCubit = context.read<DataCubit>();
                  final ListCubit listCubit = context.read<ListCubit>();
                  final ButtonCubit buttonCubit = context.read<ButtonCubit>();
                  PermissionStatus status = await Permission.storage.request();
                  if (status.isGranted) {
                    try {
                      await _onCreateDocument(
                        dataCubit.state,
                        listCubit.state,
                        buttonCubit.state,
                      );
                      if (kDebugMode) {
                        print(S.of(context).documentIsSuccessfullyOpen);
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print('$e');
                      }
                    } finally {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    }
                  } else {
                    if (kDebugMode) {
                      print(S.of(context).accessPermission);
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
