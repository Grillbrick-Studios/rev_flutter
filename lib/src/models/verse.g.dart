// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerseAdapter extends TypeAdapter<Verse> {
  @override
  final int typeId = 0;

  @override
  Verse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Verse(
      book: fields[0] as String,
      chapter: fields[1] as int,
      verse: fields[2] as int,
      heading: fields[3] as String?,
      footnotes: fields[7] as String?,
      microheading: fields[4] as bool,
      paragraph: fields[5] as bool,
      style: fields[6] as Style,
      versetext: fields[8] as String,
      hasCommentary: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Verse obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.book)
      ..writeByte(1)
      ..write(obj.chapter)
      ..writeByte(2)
      ..write(obj.verse)
      ..writeByte(3)
      ..write(obj.heading)
      ..writeByte(4)
      ..write(obj.microheading)
      ..writeByte(5)
      ..write(obj.paragraph)
      ..writeByte(6)
      ..write(obj.style)
      ..writeByte(7)
      ..write(obj.footnotes)
      ..writeByte(8)
      ..write(obj.versetext)
      ..writeByte(9)
      ..write(obj.hasCommentary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StyleAdapter extends TypeAdapter<Style> {
  @override
  final int typeId = 6;

  @override
  Style read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Style.prose;
      case 1:
        return Style.poetry;
      case 2:
        return Style.poetryNoPostGap;
      case 3:
        return Style.poetryPreGap;
      case 4:
        return Style.poetryPreGapNoPostGap;
      case 5:
        return Style.list;
      case 6:
        return Style.listNoPostGap;
      case 7:
        return Style.listPreGap;
      case 8:
        return Style.listPreGapNoPostGap;
      default:
        return Style.prose;
    }
  }

  @override
  void write(BinaryWriter writer, Style obj) {
    switch (obj) {
      case Style.prose:
        writer.writeByte(0);
        break;
      case Style.poetry:
        writer.writeByte(1);
        break;
      case Style.poetryNoPostGap:
        writer.writeByte(2);
        break;
      case Style.poetryPreGap:
        writer.writeByte(3);
        break;
      case Style.poetryPreGapNoPostGap:
        writer.writeByte(4);
        break;
      case Style.list:
        writer.writeByte(5);
        break;
      case Style.listNoPostGap:
        writer.writeByte(6);
        break;
      case Style.listPreGap:
        writer.writeByte(7);
        break;
      case Style.listPreGapNoPostGap:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
