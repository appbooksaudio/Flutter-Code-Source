class Authors {
   String imagePath;
   String at_ID;
   String at_Name;
   String at_Name_Ar;
   String at_Desc;
   String at_Desc_Ar;
   bool at_Active;
   bool isDarkMode;

   Authors({
    required this.imagePath,
    required this.at_ID,
    required this.at_Name,
    required this.at_Name_Ar,
    required this.at_Desc,
    required this.at_Desc_Ar,
    required this.at_Active,
    required this.isDarkMode,
  });
}

List<Authors> mockAuthors = [];
