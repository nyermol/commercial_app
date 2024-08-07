// ignore_for_file: always_specify_types

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show basename;

class RemarksListDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(int) onDismissed;
  final Function(int) onTap;
  final Function(int) onLongPress;
  final Function(int) iconPressed;

  const RemarksListDisplay({
    super.key,
    required this.items,
    required this.onDismissed,
    required this.onTap,
    required this.onLongPress,
    required this.iconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> item = items[index];
          return Dismissible(
              key: Key(item.toString()),
              onDismissed: (DismissDirection direction) {
                Future.delayed(Duration.zero, () {
                  onDismissed(index);
                });
              },
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item['title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: textFontSize,),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item['subtitle'] ?? '',
                      style: const TextStyle(
                          color: Colors.teal, fontSize: subtitleFontSize,),
                    ),
                    if (item['images'] != null)
                      ...item['images']
                          .map((path) => Text(
                                basename(path),
                                style:
                                    const TextStyle(fontSize: subtitleFontSize),
                              ),)
                          .toList(),
                  ],
                ),
                isThreeLine: true,
                onTap: () => onTap(index),
                onLongPress: () => onLongPress(index),
                trailing: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => iconPressed(index),
                ),
                visualDensity: const VisualDensity(vertical: -4),
              ),);
        },);
  }
}
