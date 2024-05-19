// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioAdapter extends TypeAdapter<Audio> {
  @override
  final int typeId = 3;

  @override
  Audio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Audio(
      imagePath: fields[0] as String,
      ad_ID: fields[1] as String,
      ad_Name: fields[2] as String,
      ad_Name_Ar: fields[3] as String,
      ad_Desc: fields[4] as String,
      ad_Desc_Ar: fields[5] as String,
      ad_Active: fields[6] as bool,
      ad_source: fields[7] as String?,
      ad_source_Ar: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Audio obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.ad_ID)
      ..writeByte(2)
      ..write(obj.ad_Name)
      ..writeByte(3)
      ..write(obj.ad_Name_Ar)
      ..writeByte(4)
      ..write(obj.ad_Desc)
      ..writeByte(5)
      ..write(obj.ad_Desc_Ar)
      ..writeByte(6)
      ..write(obj.ad_Active)
      ..writeByte(7)
      ..write(obj.ad_source)
      ..writeByte(8)
      ..write(obj.ad_source_Ar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
