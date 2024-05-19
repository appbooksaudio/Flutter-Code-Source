class Podcast {
   String imagePath;
   String file;
   String pd_ID;
   String pd_Name;
   String pd_Name_Ar;
   String pd_Desc;
   String pd_Desc_Ar;
   bool pd_Active;
   bool isDarkMode;

   Podcast({
    required this.imagePath,
    required this.file,
    required this.pd_ID,
    required this.pd_Name,
    required this.pd_Name_Ar,
    required this.pd_Desc,
    required this.pd_Desc_Ar,
    required this.pd_Active,
    required this.isDarkMode,
  });
}

List<Podcast> mockPoscast = [Podcast(imagePath: "https://totallyhistory.com/wp-content/uploads/2013/07/Charles-Dickens.jpg", pd_ID: "01", pd_Name: 'Psdcast01', pd_Name_Ar: 'Psdcast01', pd_Desc: 'Psdcast01', pd_Desc_Ar: 'Psdcast01', pd_Active: true, isDarkMode: true, file: ''),
Podcast(imagePath: "https://www.phillymag.com/wp-content/uploads/sites/3/2019/11/symptoms-nutrition-main.jpg", pd_ID: "01", pd_Name: 'Psdcast02', pd_Name_Ar: 'Psdcast02', pd_Desc: 'Psdcast02', pd_Desc_Ar: 'Psdcast02', pd_Active: true, isDarkMode: true, file: ''),
Podcast(imagePath: "https://www.thoughtco.com/thmb/oKFLhAPeld1Jo3p56lernqUwxsQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Walt-Whitman-3000x2400-58b9987c5f9b58af5c6ab5f7.jpg", pd_ID: "01", pd_Name: 'Psdcast03', pd_Name_Ar: 'Psdcast03', pd_Desc: 'Psdcast03', pd_Desc_Ar: 'Psdcast03', pd_Active: true, isDarkMode: true, file: ''),
Podcast(imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxzo7NzLKA3Xdjz3loaxSDNQKkK3PIf2J6ayNp6_Fq1Q&s", pd_ID: "01", pd_Name: 'Psdcast04', pd_Name_Ar: 'Psdcast04', pd_Desc: 'Psdcast04', pd_Desc_Ar: 'Psdcast04', pd_Active: true, isDarkMode: true, file: ''),
Podcast(imagePath: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTskK-5v3s16bntFS_7bpC8ANA-Xm8lbl9FgRqB2bWk73L-qwRU-a-RpIlWYaQVfGqxdGU&usqp=CAU", pd_ID: "01", pd_Name: 'Psdcast05', pd_Name_Ar: 'Psdcast05', pd_Desc: 'Psdcast05', pd_Desc_Ar: 'Psdcast05', pd_Active: true, isDarkMode: true, file: ''),
Podcast(imagePath: "https://capitalizemytitle.com/wp-content/uploads/2022/05/Booker_T_Washington_retouched_flattened-crop.jpg", pd_ID: "01", pd_Name: 'Psdcast06', pd_Name_Ar: 'Psdcast06', pd_Desc: 'Psdcast06', pd_Desc_Ar: 'Psdcast06', pd_Active: true, isDarkMode: true, file: '')];