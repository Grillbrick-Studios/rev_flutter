// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BibleAdapter extends TypeAdapter<Bible> {
  @override
  final int typeId = 3;

  @override
  Bible read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bible(
      (fields[0] as List).cast<Verse>(),
    );
  }

  @override
  void write(BinaryWriter writer, Bible obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj._data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
