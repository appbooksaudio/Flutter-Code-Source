// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 1;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      bk_ID: fields[0] as String?,
      bk_Code: fields[1] as String?,
      bk_Name: fields[2] as String?,
      bk_Name_Ar: fields[3] as String?,
      bk_Introduction: fields[4] as String?,
      bk_Introduction_Ar: fields[5] as String?,
      bk_Summary: fields[6] as String?,
      bk_Summary_Ar: fields[7] as String?,
      bk_Characters: fields[8] as String?,
      bk_Characters_Ar: fields[9] as String?,
      bk_Desc: fields[10] as String?,
      bk_Desc_Ar: fields[11] as String?,
      bk_Language: fields[12] as String?,
      bk_Language_Ar: fields[13] as String?,
      bk_Active: fields[14] as bool?,
      bk_CreatedOn: fields[15] as String?,
      bk_Modifier: fields[16] as String?,
      bk_trial: fields[17] as bool?,
      categories: (fields[21] as List).cast<dynamic>(),
      genres: (fields[22] as List).cast<dynamic>(),
      publishers: (fields[23] as List).cast<dynamic>(),
      thematicAreas: (fields[24] as List).cast<dynamic>(),
      authors: (fields[25] as List).cast<dynamic>(),
      tags: (fields[26] as List).cast<dynamic>(),
      imagePath: fields[18] as String,
      audioEn: fields[19] as String,
      audioAr: fields[20] as String,
      price: fields[27] as int?,
      quantity: fields[28] as int,
      iconCategory: fields[29] as String?,
      authoicon: fields[30] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.bk_ID)
      ..writeByte(1)
      ..write(obj.bk_Code)
      ..writeByte(2)
      ..write(obj.bk_Name)
      ..writeByte(3)
      ..write(obj.bk_Name_Ar)
      ..writeByte(4)
      ..write(obj.bk_Introduction)
      ..writeByte(5)
      ..write(obj.bk_Introduction_Ar)
      ..writeByte(6)
      ..write(obj.bk_Summary)
      ..writeByte(7)
      ..write(obj.bk_Summary_Ar)
      ..writeByte(8)
      ..write(obj.bk_Characters)
      ..writeByte(9)
      ..write(obj.bk_Characters_Ar)
      ..writeByte(10)
      ..write(obj.bk_Desc)
      ..writeByte(11)
      ..write(obj.bk_Desc_Ar)
      ..writeByte(12)
      ..write(obj.bk_Language)
      ..writeByte(13)
      ..write(obj.bk_Language_Ar)
      ..writeByte(14)
      ..write(obj.bk_Active)
      ..writeByte(15)
      ..write(obj.bk_CreatedOn)
      ..writeByte(16)
      ..write(obj.bk_Modifier)
      ..writeByte(17)
      ..write(obj.bk_trial)
      ..writeByte(18)
      ..write(obj.imagePath)
      ..writeByte(19)
      ..write(obj.audioEn)
      ..writeByte(20)
      ..write(obj.audioAr)
      ..writeByte(21)
      ..write(obj.categories)
      ..writeByte(22)
      ..write(obj.genres)
      ..writeByte(23)
      ..write(obj.publishers)
      ..writeByte(24)
      ..write(obj.thematicAreas)
      ..writeByte(25)
      ..write(obj.authors)
      ..writeByte(26)
      ..write(obj.tags)
      ..writeByte(27)
      ..write(obj.price)
      ..writeByte(28)
      ..write(obj.quantity)
      ..writeByte(29)
      ..write(obj.iconCategory)
      ..writeByte(30)
      ..write(obj.authoicon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
