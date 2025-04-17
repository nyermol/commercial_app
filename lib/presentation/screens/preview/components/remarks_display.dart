// ignore_for_file: use_build_context_synchronously

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemarksDisplay extends StatefulWidget {
  const RemarksDisplay({super.key});

  @override
  State<RemarksDisplay> createState() => _RemarksDisplayState();
}

class _RemarksDisplayState extends State<RemarksDisplay> {
  // Открытие диалога просмотра изображений при долгом нажатии
  Future<void> _showImagesGridDialog(
    BuildContext context,
    String key,
    int index,
  ) async {
    await PhotoGallery.showImagesGridDialog(context, key, index);
  }

  // Метод построения списка замечаний
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
        children.add(
          GestureDetector(
            onLongPress: () {
              if (remark.images.isNotEmpty) {
                _showImagesGridDialog(context, key, i);
              }
            },
            child: Text.rich(
              TextSpan(
                text: displayText,
                children: <InlineSpan>[
                  TextSpan(
                    text: subtitle,
                    style: TextStyle(
                      color: mainColor,
                    ),
                  ),
                ],
                style: secondaryLabelStyle,
              ),
            ),
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
