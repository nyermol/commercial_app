// ignore_for_file: library_private_types_in_public_api, always_specify_types

import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/remarks/components/remarks_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  Map<String, bool> _checkedRooms = <String, bool>{};
  Map<String, TextEditingController> _roomController =
      <String, TextEditingController>{};
  List<String> _selectedRooms = <String>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final RoomCubit roomCubit = context.read<RoomCubit>();
    final List<String> rooms = _getLocalizedRooms(context);
    await roomCubit.loadList('selectedRooms');
    _checkedRooms = await roomCubit.loadCheckedRooms(rooms);
    _roomController = await roomCubit.loadRoomControllers(rooms);
    setState(() {
      _selectedRooms = roomCubit.selectedRooms;
    });
  }

  List<String> _getLocalizedRooms(BuildContext context) {
    return <String>[
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
  }

  void _showRoomDialog({
    required BuildContext context,
    required void Function() onSave,
  }) {
    final List<String> rooms = _getLocalizedRooms(context);
    showCustomDialog(
      context: context,
      title: S.of(context).selectRoom,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialog) {
          return SizedBox(
            width: double.maxFinite,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: rooms.map((String room) {
                return ListTile(
                  title: Text(
                    room,
                    style: const TextStyle(fontSize: mainFontSize),
                  ),
                  trailing: _checkedRooms[room] == true
                      ? SizedBox(
                          width: SizeConfig.screenWidth * 0.1,
                          child: TextField(
                            controller: _roomController[room],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(numberRegExp),
                              LengthLimitingTextInputFormatter(2),
                            ],
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                            cursorColor: Colors.teal,
                            style: const TextStyle(fontSize: mainFontSize),
                          ),
                        )
                      : null,
                  selected: _checkedRooms[room] == true,
                  selectedColor: Colors.teal,
                  onTap: () {
                    setStateDialog(() {
                      _checkedRooms[room] = !_checkedRooms[room]!;
                    });
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: onSave,
          child: Text(
            S.of(context).save,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }

  void _onRoomSave() {
    final RoomCubit roomCubit = context.read<RoomCubit>();
    _getLocalizedRooms(context);
    List<String> tempSelectedRooms = <String>[];
    _checkedRooms.forEach((String room, bool checked) {
      if (checked) {
        int? count = int.tryParse(_roomController[room]!.text);
        if (count != null) {
          for (int i = 0; i < count; i++) {
            tempSelectedRooms.add('$room ${i + 1}');
          }
        } else {
          tempSelectedRooms.add(room);
        }
      }
    });
    roomCubit.saveList('selectedRooms', tempSelectedRooms);
    roomCubit.saveCheckedRooms(_checkedRooms);
    roomCubit.saveRoomControllers(_roomController);
    setState(() {
      _selectedRooms = tempSelectedRooms;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, Map<String, dynamic>>(
      builder: (BuildContext context, Map<String, dynamic> state) {
        _selectedRooms = state['selectedRooms'] ?? <String>[];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: SizeConfig.screenWidth * 0.7,
              child: DefaultButton(
                text: S.of(context).specifyRoom,
                onPressed: () => _showRoomDialog(
                  context: context,
                  onSave: _onRoomSave,
                ),
              ),
            ),
            SelectedRoomList(selectedRooms: _selectedRooms),
          ],
        );
      },
    );
  }
}
