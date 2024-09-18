// ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously, always_specify_types, avoid_print

import 'dart:html' as html;
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/preview/components/preview_export.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
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
        await rootBundle.load('assets/templates/shablon_akta.docx');
    final Uint8List bytes = data.buffer.asUint8List();
    final DocxTemplate docx = await DocxTemplate.fromBytes(bytes);

    String checkValue(dynamic value) {
      return (value == null || value == '') ? '0' : value.toString();
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
          await _createItemsContent(listState['electricsItems']),
        ),
      )
      ..add(
        ListContent(
          'geometryItems',
          await _createItemsContent(listState['geometryItems']),
        ),
      )
      ..add(
        ListContent(
          'plumbingEquipmentItems',
          await _createItemsContent(listState['plumbingEquipmentItems']),
        ),
      )
      ..add(
        ListContent(
          'windowsAndDoorsItems',
          await _createItemsContent(listState['windowsAndDoorsItems']),
        ),
      )
      ..add(
        ListContent(
          'finishingItems',
          await _createItemsContent(listState['finishingItems']),
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
      try {
        final blob = html.Blob(
          [
            doc,
          ],
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        );
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute(
            'download',
            '№${dataState['order_number'] ?? S.of(context).notSpecified} (${dataState['inspection_date'] ?? S.of(context).notSpecified}).docx',
          )
          ..click();
        html.Url.revokeObjectUrl(url);
        print('The document was successfully created and opened');
      } catch (e) {
        print('$e');
      }
    } else {
      print('Generating document error');
    }
  }

  Future<List<Content>> _createItemsContent(
    List<Map<String, dynamic>>? items,
  ) async {
    if (items == null) return <Content>[];
    return Future.wait(
      items
          .asMap()
          .entries
          .map((MapEntry<int, Map<String, dynamic>> entry) async {
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
          List<Content> imageContents = await _createImageContents(images);
          content.add(ListContent('images', imageContents));
        }
        return content;
      }).toList(),
    );
  }

  Future<List<Content>> _createImageContents(List<String> images) async {
    return Future.wait(
      images.map((String imagePath) async {
        final Uint8List? imageBytes =
            await Hive.box('imagesBox').get(imagePath);
        if (imageBytes != null) {
          final img.Image? originalImage = img.decodeImage(imageBytes);
          if (originalImage != null) {
            final img.Image correctedImage = img.bakeOrientation(originalImage);
            final Uint8List processedBytes = img.encodeJpg(correctedImage);
            return ImageContent('image', processedBytes);
          }
        }
        return ImageContent('image', Uint8List(0));
      }).toList(),
    );
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
                  primary: true,
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
                  showCustomDialog(
                    context: context,
                    title: '',
                    barrierDismissible: false,
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
                          const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
                  final DataCubit dataCubit = context.read<DataCubit>();
                  final ListCubit listCubit = context.read<ListCubit>();
                  final ButtonCubit buttonCubit = context.read<ButtonCubit>();
                  try {
                    await _onCreateDocument(
                      dataCubit.state,
                      listCubit.state,
                      buttonCubit.state,
                    );
                    print('The document was successfully created and opened');
                  } catch (e) {
                    print('$e');
                  } finally {
                    Navigator.of(context).pop();
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
