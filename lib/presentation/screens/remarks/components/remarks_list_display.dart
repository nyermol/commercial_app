// ignore_for_file: library_private_types_in_public_api, always_specify_types

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' show basename;

class RemarksListDisplay extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(int) onTap;
  final Function(int) onLongPress;
  final Function(int) iconPressed;
  final String itemsKey;

  const RemarksListDisplay({
    super.key,
    required this.items,
    required this.onTap,
    required this.onLongPress,
    required this.iconPressed,
    required this.itemsKey,
  });

  @override
  _RemarksListDisplayState createState() => _RemarksListDisplayState();
}

class _RemarksListDisplayState extends State<RemarksListDisplay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit, Map<String, dynamic>>(
      builder: (BuildContext context, Map<String, dynamic> state) {
        List<Map<String, dynamic>> itemList =
            state[widget.itemsKey] ?? <Map<String, dynamic>>[];
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> item = itemList[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                item['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item['subtitle'] ?? '',
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  if (item['images'] != null)
                    ...item['images']
                        .map(
                          (path) => Text(
                            basename(path),
                            style: const TextStyle(fontSize: subtitleFontSize),
                          ),
                        )
                        .toList(),
                ],
              ),
              isThreeLine: true,
              onTap: () => widget.onTap(index),
              onLongPress: () => widget.onLongPress(index),
              trailing: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => widget.iconPressed(index),
              ),
              visualDensity: const VisualDensity(vertical: -4),
            );
          },
        );
      },
    );
  }
}
