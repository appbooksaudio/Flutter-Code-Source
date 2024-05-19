import 'package:hive/hive.dart';

part 'audio.g.dart';

@HiveType(typeId: 3)
class Audio {
  @HiveField(0)
  String imagePath;
  @HiveField(1)
  String ad_ID;
  @HiveField(2)
  String ad_Name;
  @HiveField(3)
  String ad_Name_Ar;
  @HiveField(4)
  String ad_Desc;
  @HiveField(5)
  String ad_Desc_Ar;
  @HiveField(6)
  bool ad_Active;
  @HiveField(7)
  String? ad_source;
  @HiveField(8)
  String? ad_source_Ar;

  Audio({
    required this.imagePath,
    required this.ad_ID,
    required this.ad_Name,
    required this.ad_Name_Ar,
    required this.ad_Desc,
    required this.ad_Desc_Ar,
    required this.ad_Active,
    required this.ad_source,
    required this.ad_source_Ar,
  });
}

List<Audio> mockAudio = [];
