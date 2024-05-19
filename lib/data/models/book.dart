import 'package:hive/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 1)
class Book extends HiveObject {
  @HiveField(0)
  late final String? bk_ID;
  @HiveField(1)
  final String? bk_Code;
  @HiveField(2)
  final String? bk_Name;
  @HiveField(3)
  final String? bk_Name_Ar;
  @HiveField(4)
  final String? bk_Introduction;
  @HiveField(5)
  final String? bk_Introduction_Ar;
  @HiveField(6)
  final String? bk_Summary;
  @HiveField(7)
  final String? bk_Summary_Ar;
  @HiveField(8)
  final String? bk_Characters;
  @HiveField(9)
  final String? bk_Characters_Ar;
  @HiveField(10)
  final String? bk_Desc;
  @HiveField(11)
  final String? bk_Desc_Ar;
  @HiveField(12)
  final String? bk_Language;
  @HiveField(13)
  final String? bk_Language_Ar;
  @HiveField(14)
  final bool? bk_Active;
  @HiveField(15)
  final String? bk_CreatedOn;
  @HiveField(16)
  final String? bk_Modifier;
  @HiveField(17)
  final bool? bk_trial;
  @HiveField(18)
  final String imagePath;
  @HiveField(19)
  final String audioEn;
  @HiveField(20)
  final String audioAr;
  @HiveField(21)
  final List<dynamic> categories;
  @HiveField(22)
  final List<dynamic> genres;
  @HiveField(23)
  final List<dynamic> publishers;
  @HiveField(24)
  final List<dynamic> thematicAreas;
  @HiveField(25)
  final List<dynamic> authors;
  @HiveField(26)
  final List<dynamic> tags;
  @HiveField(27)
  final int? price;
  @HiveField(28)
  final int quantity;
  @HiveField(29)
  final String? iconCategory;
  @HiveField(30)
  final String? authoicon;

  Book({
    this.bk_ID,
    this.bk_Code,
    this.bk_Name,
    this.bk_Name_Ar,
    this.bk_Introduction,
    this.bk_Introduction_Ar,
    this.bk_Summary,
    this.bk_Summary_Ar,
    this.bk_Characters,
    this.bk_Characters_Ar,
    this.bk_Desc,
    this.bk_Desc_Ar,
    this.bk_Language,
    this.bk_Language_Ar,
    this.bk_Active,
    this.bk_CreatedOn,
    this.bk_Modifier,
    this.bk_trial,
    required this.categories,
    required this.genres,
    required this.publishers,
    required this.thematicAreas,
    required this.authors,
    required this.tags,
    required this.imagePath,
    required this.audioEn,
    required this.audioAr,
    this.price,
    this.quantity = 1,
    this.iconCategory,
    this.authoicon,
  });

  get title => null;
}

List<Book> mockBookList = [];
List<Book> collectionListById = [];
