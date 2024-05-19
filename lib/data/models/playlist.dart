import 'package:hive/hive.dart';

import 'audio.dart';

part 'playlist.g.dart';

@HiveType(typeId: 2)
class PlayList {
  @HiveField(0)
  final String? pl_id;
  @HiveField(1)
  final String? pl_image;
  @HiveField(2)
  final String? pl_title;
  @HiveField(3)
  final String? pl_title_ar;
  @HiveField(4)
  final List<Audio>? pl_audio;

  PlayList({
    this.pl_id,
    this.pl_image,
    this.pl_title,
    this.pl_title_ar,
    this.pl_audio,
  });
}

List<PlayList> mockPlayList = [];
List<PlayList> CurrenPlayList = [];
