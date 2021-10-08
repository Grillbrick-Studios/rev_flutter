// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boxes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResourceAdapter extends TypeAdapter<Resource> {
  @override
  final int typeId = 7;

  @override
  Resource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Resource.bible;
      case 1:
        return Resource.commentary;
      case 2:
        return Resource.appendix;
      default:
        return Resource.bible;
    }
  }

  @override
  void write(BinaryWriter writer, Resource obj) {
    switch (obj) {
      case Resource.bible:
        writer.writeByte(0);
        break;
      case Resource.commentary:
        writer.writeByte(1);
        break;
      case Resource.appendix:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
