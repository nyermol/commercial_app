// ignore_for_file: always_specify_types

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsSelection extends StatelessWidget {
  const RoomsSelection({super.key});

  void _showRoomSelectionDialog(BuildContext context, List<String> roomNames) {
    final RoomCubit roomCubit = context.read<RoomCubit>();
    roomCubit.syncTempSelectedRooms(roomNames);
    showCustomDialog(
      context: context,
      title: S.of(context).selectRoom,
      content: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: roomNames.length,
                itemBuilder: (BuildContext context, int index) {
                  final String roomName = roomNames[index];
                  final Room room = roomCubit.tempSelectedRooms.firstWhere(
                    (Room r) => r.name == roomName,
                    orElse: () => Room(name: roomName),
                  );
                  final bool isSelected = room.isSelected;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: textFontSize,
                      ),
                    ),
                    trailing: isSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.grey[700],
                                  shape: const CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: room.quantity > 1
                                        ? mainColor
                                        : Colors.grey,
                                  ),
                                  onPressed: room.quantity > 1
                                      ? () {
                                          setState(() {
                                            roomCubit.updateRoomQuantity(
                                              room,
                                              room.quantity - 1,
                                            );
                                          });
                                        }
                                      : null,
                                ),
                              ),
                              Padding(
                                padding: getHorizontalPadding(context, 0.05),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: SizeConfig.screenWidth * 0.05,
                                  ),
                                  child: Text(
                                    room.quantity.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: textFontSize,
                                    ),
                                  ),
                                ),
                              ),
                              Ink(
                                decoration: ShapeDecoration(
                                  color: Colors.grey[700],
                                  shape: const CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: mainColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      roomCubit.updateRoomQuantity(
                                        room,
                                        room.quantity + 1,
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        roomCubit.toggleRoomSelection(room);
                        if (room.isSelected && room.quantity < 1) {
                          roomCubit.updateRoomQuantity(room, 1);
                        }
                      });
                    },
                    selected: isSelected,
                    selectedColor: mainColor,
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            roomCubit.saveSelectedRooms(roomCubit.tempSelectedRooms);
          },
          child: Text(
            S.of(context).save,
            style: TextStyle(
              fontSize: mainFontSize,
              color: mainColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              width: SizeConfig.screenWidth * 0.8,
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
                    style: TextStyle(
                      color: mainColor,
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
