import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' show basename;

class RemarksListDisplay extends StatefulWidget {
  final List<Remark> items;
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
  State<RemarksListDisplay> createState() => _RemarksListDisplayState();
}

class _RemarksListDisplayState extends State<RemarksListDisplay> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemarksCubit, Map<String, List<Remark>>>(
      builder: (BuildContext context, Map<String, List<Remark>> state) {
        List<Remark> itemList = state[widget.itemsKey] ?? <Remark>[];
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            Remark item = itemList[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: subtitleFontSize,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF24555E),
                      fontSize: remarksFontSize,
                    ),
                  ),
                  if (item.images.isNotEmpty)
                    ...item.images.map(
                      (String path) => Text(
                        basename(path),
                        style: const TextStyle(
                          fontSize: remarksFontSize,
                        ),
                      ),
                    ),
                ],
              ),
              isThreeLine: true,
              onTap: () => widget.onTap(index),
              onLongPress: () => widget.onLongPress(index),
              trailing: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                ),
                onPressed: () => widget.iconPressed(index),
              ),
              visualDensity: const VisualDensity(
                vertical: -4,
              ),
            );
          },
        );
      },
    );
  }
}