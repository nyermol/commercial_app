// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_specify_types

part of 'remark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RemarkAdapter extends TypeAdapter<Remark> {
  @override
  final int typeId = 1;

  @override
  Remark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Remark(
      title: fields[0] as String,
      subtitle: fields[1] as String,
      gost: fields[2] as String,
      images: (fields[3] as List).cast<String>(),
      isGeneralRemark: fields[4] == null ? false : fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Remark obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subtitle)
      ..writeByte(2)
      ..write(obj.gost)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.isGeneralRemark);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
