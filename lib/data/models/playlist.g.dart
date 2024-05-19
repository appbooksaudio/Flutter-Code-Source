// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayListAdapter extends TypeAdapter<PlayList> {
  @override
  final int typeId = 2;

  @override
  PlayList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayList(
      pl_id: fields[0] as String?,
      pl_image: fields[1] as String?,
      pl_title: fields[2] as String?,
      pl_title_ar: fields[3] as String?,
      pl_audio: (fields[4] as List?)?.cast<Audio>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayList obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.pl_id)
      ..writeByte(1)
      ..write(obj.pl_image)
      ..writeByte(2)
      ..write(obj.pl_title)
      ..writeByte(3)
      ..write(obj.pl_title_ar)
      ..writeByte(4)
      ..write(obj.pl_audio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
