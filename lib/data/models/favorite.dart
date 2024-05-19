import 'package:ejazapp/data/models/book.dart';
import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 4)
class Favorite {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final Book? book;
  @HiveField(2)
  bool isLiked;

  Favorite({this.id, this.book, this.isLiked = false});
}

List<Favorite> mockFavoriteList = [];
