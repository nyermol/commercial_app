import 'package:hive/hive.dart';

part 'room.g.dart';

@HiveType(typeId: 2)
class Room {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isSelected;

  @HiveField(2)
  String controllerValue;

  @HiveField(3)
  int quantity;

  Room({
    required this.name,
    this.isSelected = false,
    this.controllerValue = '',
    this.quantity = 1,
  });

  Room copyWith({
    String? name,
    bool? isSelected,
    String? controllerValue,
    int? quantity,
  }) {
    return Room(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      controllerValue: controllerValue ?? this.controllerValue,
      quantity: quantity ?? this.quantity,
    );
  }
}
