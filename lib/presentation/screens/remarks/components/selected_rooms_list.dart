import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:flutter/material.dart';

class SelectedRoomList extends StatelessWidget {
  final List<String> selectedRooms;

  const SelectedRoomList({
    super.key,
    required this.selectedRooms,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      itemCount: selectedRooms.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            selectedRooms[index],
            style: const TextStyle(
              color: Colors.teal,
              fontSize: textFontSize,
            ),
          ),
          visualDensity: const VisualDensity(vertical: -4),
        );
      },
    );
  }
}
