// ignore_for_file: always_specify_types

import 'dart:io';

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' show basename;

class RemarksDisplay extends StatefulWidget {
  const RemarksDisplay({super.key});

  @override
  State<RemarksDisplay> createState() => _RemarksDisplayState();
}

class _RemarksDisplayState extends State<RemarksDisplay> {
  Future<void> _showImagePreview(
      BuildContext context, String imagePath, String key, int itemIndex,) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            S.of(context).imagePreview,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.file(File(imagePath)),
              Text(basename(imagePath)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(context).delete,
                style: const TextStyle(fontSize: mainFontSize),
              ),
              onPressed: () async {
                await context
                    .read<ListCubit>()
                    .removeImage(key, itemIndex, imagePath);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).leave,
                  style: const TextStyle(fontSize: mainFontSize),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryList(
      List<Map<String, dynamic>> items, String key, String sectionTitle,) {
    List<Widget> children = <Widget>[
      Text(
        '$sectionTitle:',
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: mainFontSize,),
      ),
    ];
    if (items.isEmpty) {
      children.add(Text(
        S.of(context).listEmpty,
        style: const TextStyle(fontSize: textFontSize),
      ),);
    } else {
      for (int i = 0; i < items.length; i++) {
        var title = items[i]['title'] ?? '';
        String subtitle = items[i]['subtitle']?.isNotEmpty == true
            ? ' (${items[i]['subtitle']})'
            : '';
        String displayText = '${i + 1}. $title';
        TextSpan subtitleSpan = TextSpan(
          text: subtitle,
          style: const TextStyle(color: Colors.teal),
        );
        List<Widget> childrenList = <Widget>[
          Text.rich(
            TextSpan(
                text: displayText,
                children: <InlineSpan>[subtitleSpan],
                style: secondaryLabelStyle,),
          ),
        ];
        if (items[i]['images'] != null) {
          List<String> images = List<String>.from(items[i]['images']);
          for (String image in images) {
            childrenList.add(
              GestureDetector(
                onTap: () => _showImagePreview(context, image, key, i),
                child: Text(
                  basename(image),
                  style: const TextStyle(
                      color: Colors.teal,
                      fontSize: textFontSize,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.teal,),
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
    return BlocBuilder<ListCubit, Map<String, dynamic>>(
      builder: (BuildContext context, Map<String, dynamic> state) {
        List<Map<String, dynamic>> electricsItems =
            state['electricsItems'] ?? <Map<String, dynamic>>[];
        List<Map<String, dynamic>> geometryItems =
            state['geometryItems'] ?? <Map<String, dynamic>>[];
        List<Map<String, dynamic>> plumbingEquipmentItems =
            state['plumbingEquipmentItems'] ?? <Map<String, dynamic>>[];
        List<Map<String, dynamic>> windowsAndDoorsItems =
            state['windowsAndDoorsItems'] ?? <Map<String, dynamic>>[];
        List<Map<String, dynamic>> finishingItems =
            state['finishingItems'] ?? <Map<String, dynamic>>[];

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
              _buildCategoryList(electricsItems, 'electricsItems',
                  S.of(context).electricsItems,),
              _buildCategoryList(
                  geometryItems, 'geometryItems', S.of(context).geometryItems,),
              _buildCategoryList(
                  plumbingEquipmentItems,
                  'plumbingEquipmentItems',
                  S.of(context).plumbingEquipmentItems,),
              _buildCategoryList(windowsAndDoorsItems, 'windowsAndDoorsItems',
                  S.of(context).windowsAndDoorsItems,),
              _buildCategoryList(finishingItems, 'finishingItems',
                  S.of(context).finishingItems,),
            ],
          ),
        );
      },
    );
  }
}
