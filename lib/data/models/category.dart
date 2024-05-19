class CategoryL {
  final String ct_ID;
  final String ct_Name;
  final String ct_Name_Ar;
  final String ct_Title;
  final String ct_Title_Ar;
  final String md_ID;

  final String imagePath;
  final String title;
  final int id;

  const CategoryL({
    required this.ct_ID,
    required this.ct_Name,
    required this.ct_Name_Ar,
    required this.ct_Title,
    required this.ct_Title_Ar,
    required this.md_ID,
    required this.imagePath,
    required this.title,
    required this.id,
  });
}

List<CategoryL> CategoryList = [];
