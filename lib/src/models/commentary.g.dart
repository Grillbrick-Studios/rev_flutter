// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  final int typeId = 4;

  @override
  Comment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.book)
      ..writeByte(1)
      ..write(obj.chapter)
      ..writeByte(2)
      ..write(obj.verse)
      ..writeByte(3)
      ..write(obj.commentary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommentaryAdapter extends TypeAdapter<Commentary> {
  @override
  final int typeId = 5;

  @override
  Commentary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Commentary(
      (fields[0] as List).cast<Comment>(),
    );
  }

  @override
  void write(BinaryWriter writer, Commentary obj) {
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
      other is CommentaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
