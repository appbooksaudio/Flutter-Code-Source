class Collections {
  final String? bc_ID;
  final String? imagePath;
  final String bc_Title;
  final String bc_Title_Ar;
  final String bc_Desc;
  final int bc_Summaries;
  final bool bc_Active;

  Collections(
      {this.bc_ID,
      required this.imagePath,
      required this.bc_Title,
      required this.bc_Title_Ar,
      required this.bc_Desc,
      required this.bc_Active,
      required this.bc_Summaries});
}

List<Collections> collectionList = [];
