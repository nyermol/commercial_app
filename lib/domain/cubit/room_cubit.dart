import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomCubit extends Cubit<Map<String, List<Room>>> {
  final SaveRoomsUsecase saveRoomsUsecase;
  final LoadRoomsUsecase loadRoomsUsecase;

  RoomCubit({
    required this.saveRoomsUsecase,
    required this.loadRoomsUsecase,
    // ignore: always_specify_types
  }) : super({});

  List<Room> tempSelectedRooms = <Room>[];
  List<Room> originalSelectedRooms = <Room>[];

  void syncTempSelectedRooms(List<String> roomNames) {
    tempSelectedRooms = roomNames.map((String name) {
      final Room room = originalSelectedRooms.firstWhere(
        (Room r) => r.name == name,
        orElse: () => Room(name: name),
      );
      return room.copyWith(
        isSelected: room.isSelected,
        quantity: room.quantity,
      );
    }).toList();
  }

  Future<void> saveSelectedRooms(List<Room> selectedRooms) async {
    List<Room> expandedRooms = <Room>[];
    originalSelectedRooms = selectedRooms.map((Room room) {
      return room.copyWith();
    }).toList();

    for (Room room in selectedRooms) {
      if (room.isSelected && room.quantity > 1) {
        for (int i = 1; i <= room.quantity; i++) {
          expandedRooms.add(room.copyWith(name: '${room.name} $i'));
        }
      } else if (room.isSelected) {
        expandedRooms.add(room);
      }
    }
    await saveRoomsUsecase(expandedRooms);
    emit(<String, List<Room>>{'selectedRooms': expandedRooms});
  }

  Future<void> loadSelectedRooms() async {
    final List<Room> selectedRooms = await loadRoomsUsecase(<String>[]);
    originalSelectedRooms = selectedRooms.map((Room room) {
      return room.copyWith();
    }).toList();
    emit(<String, List<Room>>{'selectedRooms': selectedRooms});
  }

  List<Room> get selectedRooms => state['selectedRooms'] ?? <Room>[];
  bool get hasSelectedRooms => selectedRooms.isNotEmpty;

  void toggleRoomSelection(Room room) {
    int index = tempSelectedRooms.indexWhere((Room r) => r.name == room.name);
    if (index >= 0) {
      if (tempSelectedRooms[index].isSelected) {
        tempSelectedRooms[index] = tempSelectedRooms[index].copyWith(
          isSelected: false,
          quantity: 1,
        );
        tempSelectedRooms.removeAt(index);
        originalSelectedRooms.removeWhere((Room r) => r.name == room.name);
      } else {
        tempSelectedRooms[index] =
            tempSelectedRooms[index].copyWith(isSelected: true);
      }
    } else {
      tempSelectedRooms.add(room.copyWith(isSelected: true));
    }
  }

  void updateRoomQuantity(Room room, int? quantity) {
    int index = tempSelectedRooms.indexWhere((Room r) => r.name == room.name);
    final int newQuantity = quantity ?? 1;
    if (index >= 0) {
      tempSelectedRooms[index] = tempSelectedRooms[index].copyWith(
        quantity: quantity != null && quantity > 1 ? newQuantity : 1,
        isSelected: true,
      );
    } else {
      tempSelectedRooms.add(
        room.copyWith(
          quantity: quantity != null && quantity > 1 ? newQuantity : 1,
          isSelected: true,
        ),
      );
    }
  }
}
