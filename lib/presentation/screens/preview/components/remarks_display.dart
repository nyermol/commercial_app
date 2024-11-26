// ignore_for_file: use_build_context_synchronously

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class RemarksDisplay extends StatefulWidget {
  const RemarksDisplay({super.key});

  @override
  State<RemarksDisplay> createState() => _RemarksDisplayState();
}

class _RemarksDisplayState extends State<RemarksDisplay> {
  Future<void> _showImagePreview(
    BuildContext context,
    Uint8List imageData,
    String imageName,
    String key,
    int itemIndex,
  ) async {
    return showCustomDialog(
      context: context,
      title: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.memory(imageData),
          Text(imageName),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            S.of(context).delete,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Colors.red,
            ),
          ),
          onPressed: () async {
            await context
                .read<RemarksCubit>()
                .removeImage(key, itemIndex, imageName);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            S.of(context).leave,
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

  Widget _buildCategoryList(
    List<Remark> items,
    String key,
    String sectionTitle,
  ) {
    List<Widget> children = <Widget>[
      Text(
        '$sectionTitle:',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: remarksFontSize,
        ),
      ),
    ];
    if (items.isEmpty) {
      children.add(
        Text(
          S.of(context).listEmpty,
          style: const TextStyle(
            fontSize: remarksFontSize,
          ),
        ),
      );
    } else {
      for (int i = 0; i < items.length; i++) {
        Remark remark = items[i];
        String subtitle =
            remark.subtitle.isNotEmpty ? ' (${remark.subtitle})' : '';
        String displayText = '${i + 1}. ${remark.title}';
        TextSpan subtitleSpan = TextSpan(
          text: subtitle,
          style: const TextStyle(
            color: Color(0xFF24555E),
          ),
        );
        List<Widget> childrenList = <Widget>[
          Text.rich(
            TextSpan(
              text: displayText,
              children: <InlineSpan>[subtitleSpan],
              style: secondaryLabelStyle,
            ),
          ),
        ];
        if (remark.images.isNotEmpty) {
          for (String image in remark.images) {
            childrenList.add(
              GestureDetector(
                onTap: () async {
                  final Box<Uint8List> imagesBox =
                      Hive.box<Uint8List>('imagesBox');
                  Uint8List? imageData = imagesBox.get(image);
                  if (imageData != null) {
                    _showImagePreview(context, imageData, image, key, i);
                  }
                },
                child: Text(
                  image,
                  style: const TextStyle(
                    color: Color(0xFF24555E),
                    fontSize: remarksFontSize,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF24555E),
                  ),
                ),
              ),
            );
          }
        }
        children.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: childrenList,
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemarksCubit, Map<String, List<Remark>>>(
      builder: (BuildContext context, Map<String, List<Remark>> state) {
        List<Remark> electricsItems = state['electricsItems'] ?? <Remark>[];
        List<Remark> geometryItems = state['geometryItems'] ?? <Remark>[];
        List<Remark> plumbingEquipmentItems =
            state['plumbingEquipmentItems'] ?? <Remark>[];
        List<Remark> windowsAndDoorsItems =
            state['windowsAndDoorsItems'] ?? <Remark>[];
        List<Remark> finishingItems = state['finishingItems'] ?? <Remark>[];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  S.of(context).remarksList,
                  style: titleStyle,
                ),
              ),
              _buildCategoryList(
                electricsItems,
                'electricsItems',
                S.of(context).electricsItems,
              ),
              _buildCategoryList(
                geometryItems,
                'geometryItems',
                S.of(context).geometryItems,
              ),
              _buildCategoryList(
                plumbingEquipmentItems,
                'plumbingEquipmentItems',
                S.of(context).plumbingEquipmentItems,
              ),
              _buildCategoryList(
                windowsAndDoorsItems,
                'windowsAndDoorsItems',
                S.of(context).windowsAndDoorsItems,
              ),
              _buildCategoryList(
                finishingItems,
                'finishingItems',
                S.of(context).finishingItems,
              ),
            ],
          ),
        );
      },
    );
  }
}
