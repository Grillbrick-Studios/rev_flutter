// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appendices.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppendixAdapter extends TypeAdapter<_Appendix> {
  @override
  final int typeId = 1;

  @override
  _Appendix read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _Appendix(
      title: fields[0] as String,
      appendix: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _Appendix obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.appendix);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppendixAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppendicesAdapter extends TypeAdapter<Appendices> {
  @override
  final int typeId = 2;

  @override
  Appendices read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appendices(
      (fields[0] as List).cast<_Appendix>(),
    );
  }

  @override
  void write(BinaryWriter writer, Appendices obj) {
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
      other is AppendicesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
