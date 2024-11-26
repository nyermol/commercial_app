// ignore_for_file: always_specify_types

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsSelection extends StatelessWidget {
  const RoomsSelection({super.key});

  void _showRoomSelectionDialog(BuildContext context, List<String> roomNames) {
    final RoomCubit roomCubit = context.read<RoomCubit>();
    roomCubit.syncTempSelectedRooms(roomNames);
    final Map<String, TextEditingController> controllers =
        <String, TextEditingController>{};
    for (Room room in roomCubit.tempSelectedRooms) {
      controllers[room.name] = TextEditingController(
        text: room.isSelected && room.quantity > 1
            ? room.quantity.toString()
            : '',
      );
    }
    showCustomDialog(
      context: context,
      title: S.of(context).selectRoom,
      content: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: roomNames.length,
              itemBuilder: (BuildContext context, int index) {
                final String roomName = roomNames[index];
                final Room room = roomCubit.tempSelectedRooms.firstWhere(
                  (Room r) => r.name == roomName,
                  orElse: () => Room(name: roomName),
                );
                final bool isSelected = room.isSelected;
                return ListTile(
                  title: Text(
                    room.name,
                    style: const TextStyle(
                      fontSize: mainFontSize,
                    ),
                  ),
                  trailing: isSelected
                      ? SizedBox(
                          width: SizeConfig.screenWidth * 0.1,
                          child: TextField(
                            controller: controllers[roomName],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF24555E),
                                ),
                              ),
                            ),
                            cursorColor: const Color(0xFF24555E),
                            style: const TextStyle(
                              fontSize: mainFontSize,
                            ),
                            onChanged: (String value) {
                              final int? quantity = int.tryParse(value);
                              setState(() {
                                roomCubit.updateRoomQuantity(
                                  room,
                                  quantity ?? 1,
                                );
                              });
                            },
                          ),
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      roomCubit.toggleRoomSelection(room);
                      if (!room.isSelected) {
                        controllers[roomName]?.clear();
                      }
                    });
                  },
                  selected: isSelected,
                  selectedColor: const Color(0xFF24555E),
                );
              },
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            roomCubit.saveSelectedRooms(roomCubit.tempSelectedRooms);
          },
          child: Text(
            S.of(context).save,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Color(0xFF24555E),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> roomNames = <String>[
      S.of(context).commercialSpace,
      S.of(context).room,
      S.of(context).kitchen,
      S.of(context).kitchenLivingRoom,
      S.of(context).hall,
      S.of(context).balcony,
      S.of(context).bath,
      S.of(context).bathroom,
      S.of(context).wardrobe,
    ];

    return BlocBuilder<RoomCubit, Map<String, List<Room>>>(
      builder: (BuildContext context, Map<String, List<Room>> state) {
        final RoomCubit roomCubit = context.read<RoomCubit>();
        final List<Room> selectedRooms = roomCubit.selectedRooms;
        final String buttonText = roomCubit.hasSelectedRooms
            ? S.of(context).changeRoom
            : S.of(context).specifyRoom;
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: SizeConfig.screenWidth * 0.7,
              child: DefaultButton(
                text: buttonText,
                onPressed: () => _showRoomSelectionDialog(context, roomNames),
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: selectedRooms.map((Room room) {
                return ListTile(
                  title: Text(
                    room.name,
                    style: const TextStyle(
                      color: Color(0xFF24555E),
                      fontSize: textFontSize,
                    ),
                  ),
                  visualDensity: const VisualDensity(
                    vertical: -4,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
