// ignore_for_file: avoid_web_libraries_in_flutter, always_specify_types

import 'dart:html' as html;
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import 'package:image/image.dart' as img;

class DocumentRepositoryImpl implements DocumentGeneratorRepository {
  final DocumentConverterRepository documentConverterRepository;

  DocumentRepositoryImpl({required this.documentConverterRepository});
  @override
  Future<void> generateDocument(
    Map<String, dynamic> dataState,
    Map<String, List<Remark>> remarksState,
    Map<String, dynamic> buttonState,
  ) async {
    try {
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
            dataState['order_number'] ?? S.current.notSpecified,
          ),
        )
        ..add(
          TextContent(
            'inspectionDate',
            dataState['inspection_date'] ?? S.current.notSpecified,
          ),
        )
        ..add(
          TextContent(
            'specialistName',
            dataState['specialist_name'] ?? S.current.notSpecified,
          ),
        )
        ..add(
          TextContent(
            'customerName',
            dataState['customer_name'] ?? S.current.notSpecified,
          ),
        )
        ..add(
          TextContent(
            'radiation',
            checkValue(
              dataState['radiation'],
            ),
          ),
        )
        ..add(
          TextContent(
            'ammonia',
            checkValue(
              dataState['ammonia'],
            ),
          ),
        )
        ..add(
          TextContent(
            'electromagneticField',
            checkValue(
              dataState['electromagneticField'],
            ),
          ),
        )
        ..add(
          TextContent(
            'airflowKitchen',
            checkValue(
              dataState['airflowKitchen'],
            ),
          ),
        )
        ..add(
          TextContent(
            'airflowSU1',
            checkValue(
              dataState['airflowSU1'],
            ),
          ),
        )
        ..add(
          TextContent(
            'airflowSU2',
            checkValue(
              dataState['airflowSU2'],
            ),
          ),
        )
        ..add(
          TextContent(
            'airflowSU3',
            checkValue(
              dataState['airflowSU3'],
            ),
          ),
        )
        ..add(
          ListContent(
            'electricsItems',
            await _createItemsContent(
              remarksState['electricsItems'],
            ),
          ),
        )
        ..add(
          ListContent(
            'geometryItems',
            await _createItemsContent(
              remarksState['geometryItems'],
            ),
          ),
        )
        ..add(
          ListContent(
            'plumbingEquipmentItems',
            await _createItemsContent(
              remarksState['plumbingEquipmentItems'],
            ),
          ),
        )
        ..add(
          ListContent(
            'windowsAndDoorsItems',
            await _createItemsContent(
              remarksState['windowsAndDoorsItems'],
            ),
          ),
        )
        ..add(
          ListContent(
            'finishingItems',
            await _createItemsContent(
              remarksState['finishingItems'],
            ),
          ),
        );

      buttonState.forEach((String key, value) {
        if (value == S.current.yes) {
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
        final String fileName =
            '№${dataState['order_number'] ?? S.current.notSpecified} (${dataState['inspection_date'] ?? S.current.notSpecified})';
        final Box<List<int>> documentsBox = Hive.box<List<int>>('documentsBox');
        await documentsBox.put(fileName, doc);
        final String? result =
            await documentConverterRepository.convertDocxToPdf(doc, fileName);

        if (result != null && result.startsWith('http')) {
          html.AnchorElement(href: result)
            ..setAttribute('download', '$fileName.pdf')
            ..click();
        } else {
          throw Exception(result);
        }
      } else {
        throw Exception('Document generation failed.');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error in generateDocument: $e');
      rethrow;
    }
  }

  Future<List<Content>> _createItemsContent(
    List<Remark>? items,
  ) async {
    if (items == null) return <Content>[];
    return Future.wait(
      items.asMap().entries.map((MapEntry<int, Remark> entry) async {
        int index = entry.key + 1;
        Remark item = entry.value;
        String titleText = '$index. ${item.title}';
        TextContent content = TextContent('title', titleText);
        String subtitleText =
            item.subtitle.trim().isEmpty ? '' : '(${item.subtitle})';
        content.add(
          TextContent('subtitle', subtitleText),
        );
        String gostText = item.gost.trim().isEmpty ? '' : item.gost;
        content.add(
          TextContent('gost', gostText),
        );
        if ((item.images).isNotEmpty) {
          List<String> images = List<String>.from(item.images);
          List<Content> imageContents = await _createImageContents(images);
          content.add(
            ListContent('images', imageContents),
          );
        }
        return content;
      }).toList(),
    );
  }

  Future<List<Content>> _createImageContents(List<String> images) async {
    return Future.wait(
      images.map((String imagePath) async {
        final Box<Uint8List> imagesBox = Hive.box<Uint8List>('imagesBox');
        final Uint8List? imageBytes = imagesBox.get(imagePath);
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
}
