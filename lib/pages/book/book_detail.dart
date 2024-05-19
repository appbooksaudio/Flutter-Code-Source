import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_progress_button/custom_progress_button.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/models/authors.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/data/models/favorite.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/pages/book/discussion/util.dart';
import 'package:ejazapp/providers/animation_test_play.dart';
import 'package:ejazapp/providers/audio_provider.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key});
  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>
    with SingleTickerProviderStateMixin {
  // ScrollController? _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  bool _isLiked = false;
  final int _sumPrice = 0;
  int _sumQuantity = 1;
  String file = "";
  String LanguageStatus = "en";
  double ratingnumber = 0.0;

  Book? book;

  @override
  void initState() {
    super.initState();
    book = Get.arguments[0] as Book;
    file = Get.arguments[1] as String;
    LanguageStatus = Get.arguments[2] as String;
// ******** initiale hive storage **********
    initHiveStorage(book);
// ******** GetRating **********
    GetRating();
// ******** Screenshot disabled **********
    ScreenShotDisabled();
  }

  // ignore: always_declare_return_types, inference_failure_on_function_return_type
  initHiveStorage(Book? book) async {
    var box = await Hive.openBox('favorite');
    var currentfav = box.get('favorite') != null ? box.get('favorite') : null;
    if (currentfav != null) {
      List<dynamic> Listfav = [];
      Listfav = currentfav as List<dynamic>;
      mockFavoriteList = Listfav.cast<Favorite>();
      final favorite = mockFavoriteList.singleWhere(
        (e) => e.id == book!.bk_ID,
        orElse: Favorite.new,
      );
      _isLiked = favorite.isLiked;
      setState(() {});
    }
  }

  void ScreenShotDisabled() async {
    (Platform.isAndroid)
        ? await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE)
        : "";
  }

  @override
  void dispose() {
    (Platform.isAndroid)
        ? FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE)
        : "";
    super.dispose();
  }

  void GetRating() async {
    List<String> numberRating = [];
    DocumentSnapshot<Map<String, dynamic>> data_rating = await FirebaseFirestore
        .instance
        .collection('rating_book')
        .doc(book!.bk_ID)
        .get();
    Map<String, dynamic>? docData = await data_rating.data();
    if (docData != null) {
      int result = 0;
      List<dynamic> ratingbook = (docData["rating"] as List<dynamic>)
          .map((rating) => Map<String, dynamic>.from(rating))
          .toList();

      ratingbook.asMap().forEach((c, value) {
        for (String key in value.keys) {
          print(key);
          print(value[key]);
          numberRating.add((value[key]).round().toString());
        }
      });
      for (var j = 0; j < numberRating.length; j++) {
        result = result + int.parse(numberRating[j]) ;
      }
      print(result / numberRating.length);
      setState(() {
        ratingnumber = (result / numberRating.length).toDouble();
      });
    }
  }

  initLang() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);

    //initLang();
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          height: Platform.isIOS ? 93.0 : 93.0, //
          color: themeProv.isDarkTheme!
              ? ColorLight.background
              : ColorDark.background,
          shape: const CircularNotchedRectangle(),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed<dynamic>(Routes.takeway,
                        arguments: [book, localprovider.locale!.languageCode]);
                  },
                  icon: Column(children: [
                    const Icon(
                      size: 31.0,
                      Icons.assignment_outlined,
                      color: ColorLight.primary,
                    ),
                    Text(
                      AppLocalizations.of(context)!.takeaway,
                      style: const TextStyle(
                        fontSize: 10,
                        color: ColorLight.primary,
                      ),
                    ),
                  ]),
                  label: const Text(
                    '',
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    //********************** Start Open Screen Audio **************//
                    late var player =
                        Provider.of<MyState>(context, listen: false).player;
                    print("playing $player");
                    if (player != null) {
                      await player.stop();
                      await player.dispose();
                      player = null;
                      Provider.of<Testplay>(context, listen: false)
                          .isTestplay(false);
                      //await  player.;

                      print("dispose player done");
                    }
                    if (book!.audioAr != Const.UrlAu &&
                        book!.audioEn != Const.UrlAu) {
                      await Get.toNamed<dynamic>(Routes.audiobook, arguments: [
                        book,
                        localprovider,
                        file,
                        localprovider.locale!.languageCode
                      ]);
                    } else {
                      Get.snackbar(
                         LanguageStatus == 'en' ?'Alert':'تنبيه',
                         LanguageStatus == 'en' ?'No Audio For this book':'لا يوجد تسجيل صوتي لهذا الكتاب',
                        colorText: Colors.white,
                        backgroundColor: Colors.redAccent,
                        icon: const Icon(Icons.audio_file),
                      );
                    }
                    //********************** End Open Screen Audio **************//
                  } // ignore: avoid_dynamic_calls
                  ,
                  icon: Column(children: [
                    const Icon(
                      size: 31.0,
                      Icons.play_circle_outline_outlined,
                      color: ColorLight.primary,
                    ),
                    Text(
                      AppLocalizations.of(context)!.audio,
                      style: const TextStyle(
                        fontSize: 10,
                        color: ColorLight.primary,
                      ),
                    ),
                  ]),
                  label: const Text(
                    '',
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final name = mybox!.get('name');
                    name != 'Guest'
                        ? Get.toNamed<dynamic>(Routes.comentpage,
                            arguments: book //comment,
                            )
                        : Get.showSnackbar(GetSnackBar(
                            title: 'Ejaz',
                            message: AppLocalizations.of(context)!
                                .messagetoguestuser,
                            duration: const Duration(seconds: 5),
                            titleText: Column(
                              children: [],
                            ),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            icon: const Icon(Icons.login),
                          ));
                  } // ignore: avoid_dynamic_calls
                  ,
                  icon: Column(children: [
                    const Icon(
                      size: 31.0,
                      Icons.forum_outlined,
                      color: ColorLight.primary,
                    ),
                    Text(
                      AppLocalizations.of(context)!.ejazclub,
                      style: const TextStyle(
                        fontSize: 10,
                        color: ColorLight.primary,
                      ),
                    ),
                  ]),
                  label: const Text(
                    '',
                  ),
                ),
              ])),
      body: NestedScrollView(
        body: Stack(children: [
          //  if (_showAppbar) buildAppBar(context) else const SizedBox(),
          buildMainSection(
            context,
            child: Column(
              children: [
                if (_showAppbar) buildAppBar(context) else const SizedBox(),
                const SizedBox(height: 50),
                buildBookImagePriceAndCounter(theme),
                const SizedBox(height: 30),
                buildBookName(theme),
                const SizedBox(height: 5),
                buildraking(theme),
                //buildBookIngredients(theme),
                const SizedBox(height: 5),
                buildBookAutho(theme),
                const SizedBox(height: 10),
                buildBookTab(theme),
              ],
            ),
          ),
        ] // buildButtonAddToCart(theme),
            ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
                backgroundColor: theme.colorScheme.background,
                foregroundColor:
                    themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
                // backgroundColor: themeProv.isDarkTheme!
                //     ? ColorDark.background
                //     : Colors.white,
                pinned: true,
                centerTitle: true,
                automaticallyImplyLeading: true),
          ];
        },
      ),
    );
  }

  Positioned buildButtonAddToCart(ThemeData theme) {
    return Positioned(child: buildBookTab(theme));
  }

  SizedBox buildAppBar(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           
   
          OutlinedButton.icon(
            onPressed: () {
              if (LanguageStatus == 'en') {
                setState(() {
                  LanguageStatus = 'ar';
                });
              } else {
                setState(() {
                  LanguageStatus = 'en';
                });
              }
              setState(() {});
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                themeProv.isDarkTheme! ? ColorDark.background : Colors.white,
              ),
            ),
            icon: const Icon(Icons.language, size: 30),
            label: Container()
            // Padding(
            //   padding: LanguageStatus == 'ar'
            //       ? EdgeInsets.only(top: 5.0)
            //       : EdgeInsets.only(top: 0.0),
            //   child: Text(
            //     LanguageStatus == 'ar' ? "En" : "ع",
            //     style: LanguageStatus == 'ar'
            //         ? TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            //         : TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.star_border),
                color: Colors.amber,
                iconSize: 30,
                onPressed: () {
                  showAlertDialog(context,LanguageStatus);
                },
              ),
              IconButton(
                icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                color: Theme.of(context).primaryColor,
                iconSize: 30,
                onPressed: () {
                  favoriteOnTap(book);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildBookTab(ThemeData theme) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Column(children: [
      buildBookSummary(context),
    ]);
  }

  SizedBox buildBookIngredients(ThemeData theme) {
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        runSpacing: 10,
        children: book!.tags
            .map(
              (e) => Row(
                //  mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    backgroundColor: ColorLight.primary,
                    radius: 3,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    LanguageStatus == 'ar'
                        ? e['tg_Title_Ar'] as String
                        : e['tg_Title'] as String,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF0088CE),
                        fontWeight: FontWeight.bold),
                    selectionColor: Colors.green,
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  SizedBox buildBookImagePriceAndCounter(ThemeData theme) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          Positioned(
            //left: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: OctoImage(
                  image: CachedNetworkImageProvider(
                    book!.imagePath,
                  ),
                  fit: BoxFit.contain,
                  height: 200,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 0,
            child: SizedBox(
              width: 50,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CloseRawSnakerbar() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  Column buildBookSummary(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Wrap(
            runSpacing: 10,
            children: book!.publishers
                .map((e) => Row(
                      textDirection: LanguageStatus == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        const Icon(Feather.book_open),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            LanguageStatus == 'ar'
                                ? ' الناشر:  ${e['pb_Title_Ar']!}'
                                : 'Publisher : ${e['pb_Title']!}',
                            textAlign: LanguageStatus == 'ar'
                                ? TextAlign.right
                                : TextAlign.left,
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: themeProv.isDarkTheme!
                                    ? Colors.white
                                    : ColorDark.background,
                                fontWeight: FontWeight.bold),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ))
                .toList()),
        const SizedBox(
          height: 10,
        ),
        Row(
          textDirection:
              LanguageStatus == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              Feather.tag,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              LanguageStatus == 'ar'
                  ? ' رقم الإيداع: ${book!.bk_Code!}'
                  : 'ISBN : ${book!.bk_Code!}',
              textAlign:
                  LanguageStatus == 'ar' ? TextAlign.right : TextAlign.left,
              style: theme.textTheme.bodyLarge!.copyWith(
                  color: themeProv.isDarkTheme!
                      ? Colors.white
                      : ColorDark.background,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        buildBookDescription(context),
      ],
    );
  }

  Padding buildBookDescription(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    final theme = Theme.of(context);
    var lang = mybox!.get('lang');
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                  LanguageStatus == 'ar'
                      ? 'مقدمة'
                      : 'Introduction', //AppLocalizations.of(context)!.introduction,
                  textAlign:
                      LanguageStatus == 'ar' ? TextAlign.right : TextAlign.left,
                  style: theme.textTheme.headlineLarge!
                      .copyWith(fontSize: 25, fontWeight: FontWeight.w500)),
            ),
            Text(
                LanguageStatus == 'ar'
                    ? book!.bk_Introduction_Ar!
                    : book!.bk_Introduction!,
                textAlign:
                    LanguageStatus == 'ar' ? TextAlign.right : TextAlign.left,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                  book!.genres[0]['gn_Title'] == 'Fiction'
                      ? LanguageStatus == 'en'
                          ? 'Story'
                          : 'قصة'
                      : LanguageStatus == 'en'
                          ? 'Overview'
                          : 'ملخص', //AppLocalizations.of(context)!.story,
                  textAlign:
                      LanguageStatus == 'ar' ? TextAlign.right : TextAlign.left,
                  style: theme.textTheme.headlineLarge!
                      .copyWith(fontSize: 25, fontWeight: FontWeight.w500)),
            ),
            Text(
                LanguageStatus == 'ar'
                    ? book!.bk_Summary_Ar!
                    : book!.bk_Summary!,
                textAlign:
                    LanguageStatus == 'ar' ? TextAlign.right : TextAlign.left,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                  book!.genres[0]['gn_Title'] == 'Fiction'
                      ? LanguageStatus == 'en'
                          ? 'Characters'
                          : 'الشخصيات'
                      : '', //AppLocalizations.of(context)!.characters,
                  textAlign:
                      LanguageStatus == 'ar' ? TextAlign.right : TextAlign.left,
                  style: theme.textTheme.headlineLarge!
                      .copyWith(fontSize: 25, fontWeight: FontWeight.w500)),
            ),
            Text(
                book!.genres[0]['gn_Title'] == 'Fiction'
                    ? LanguageStatus == 'ar'
                        ? book!.bk_Characters_Ar!
                        : book!.bk_Characters!
                    : '',
                textAlign:
                    LanguageStatus == 'ar' ? TextAlign.right : TextAlign.left,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Text buildBookName(ThemeData theme) {
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Text(
      textAlign: TextAlign.center,
      LanguageStatus == 'ar' ? book!.bk_Name_Ar! : book!.bk_Name!,
      style: theme.textTheme.headlineLarge!.copyWith(fontSize: 25, height: 1.2),
    );
  }

  Container buildraking(ThemeData theme) {
    return Container(
      height: 50,
      width: double.infinity,
      child: Center(
        child: RatingBarIndicator(
           textDirection: LanguageStatus == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
          rating: ratingnumber.toDouble(),
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 30.0,
          direction: Axis.horizontal,
        ),
      ),
    );
  }

  Row buildBookAutho(ThemeData theme) {
    int i = 0;
    Authors? authors;
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Row(
      textDirection:
          LanguageStatus == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Row(
          children: book!.authors
              .map((e) => InkWell(
                    onTap: () {
                      authors = Authors(
                          at_Active: e['at_Active'],
                          at_Desc: e['at_Desc'],
                          at_Desc_Ar: e['at_Desc_Ar'],
                          at_ID: e['at_ID'],
                          at_Name: e['at_Name'],
                          at_Name_Ar: e['at_Name_Ar'],
                          imagePath:
                              'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/${e['md_ID']}',
                          isDarkMode: false);

                      Get.toNamed(Routes.authors, arguments: authors);
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.only(left: i++ * 0.1),
                        // left: i++ * 30,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/${e['md_ID']}'),
                          radius: 30,
                        )),
                  ))
              .toList(),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Wrap(
              runSpacing: 1,
              children: book!.authors
                  .asMap()
                  .map((i, e) => MapEntry(
                        i,
                        InkWell(
                          onTap: () {
                            authors = Authors(
                                at_Active: e['at_Active'],
                                at_Desc: e['at_Desc'],
                                at_Desc_Ar: e['at_Desc_Ar'],
                                at_ID: e['at_ID'],
                                at_Name: e['at_Name'],
                                at_Name_Ar: e['at_Name_Ar'],
                                imagePath:
                                    'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/${e['md_ID']}',
                                isDarkMode: false);

                            Get.toNamed(Routes.authors, arguments: authors);
                          },
                          child: Text(
                            LanguageStatus == 'ar'
                                ? i < book!.authors.length - 1 == true
                                    ? e['at_Name_Ar'] + ' و ' as String
                                    : e['at_Name_Ar'] + ' ' as String
                                : i < book!.authors.length - 1 == true
                                    ? e['at_Name'] + ' & ' as String
                                    : e['at_Name'] + ' ' as String,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(height: 1.5, fontSize: 11)
                                .copyWith(color: Colors.lightBlue),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                          ),
                        ),
                      ))
                  .values
                  .toList(),
            ),
          ],
        )
      ],
    );
  }

  Positioned buildMainSection(BuildContext context, {Widget? child}) {
    final themeProv = Provider.of<ThemeProvider>(context);
   
    return Positioned.fill(
      child: SingleChildScrollView(
        // controller: _scrollViewController,
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Const.margin),
          child: child,
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context,String lang) async {

   
    // set up the buttons
    Widget cancelButton = MaterialButton(
      minWidth: 120,
        height: 45,
        color: Color.fromARGB(255, 247, 132, 132),
      child: Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(lang == 'en'? "Cancel":"اِلغِ",
       style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = 
    MaterialButton(
        minWidth: 120,
        height: 45,
       color: ColorLight.primary,
      child: Padding(
       padding: EdgeInsets.only(top: 5.0),
        child: Text(lang == 'en' ? "Continue":'تابع',
          style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,),
      ),
      onPressed: () {
         Navigator.pop(context);
        RatingBook(ratingnumber,lang);
      
      },
    );
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.only(
          bottom: height * 0.35,
          top: height * 0.19,
          left: width * 0.02,
          right: width * 0.02),
      title: Center(
          child: Text(lang == 'en' ?
        "Rating Book" :'تقييم الكتاب',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
        textAlign: TextAlign.center,
      )),
      content: Center(
        child: Column(
          children: [
            Center(
                child: Text(lang == 'en' ?
              "How was book summaries? ":'ما رأيك بملخصات الكتب؟',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
            SizedBox(
              height: height * 0.03,
            ),
            Center(
              child: RatingBar.builder(
                 textDirection: LanguageStatus == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                itemSize: 50,
                initialRating: 3.0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    ratingnumber = rating;
                  });
                  print(rating);
                },
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Center(
                child: Text(lang == 'en' ?
              "Your feedback will help us improve book summaries better?":'هل ساهمت ملاحظاتك في تحسين ملخصات الكتب؟',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
            
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(height: 300, child: alert);
      },
    );
  }

  void RatingBook(
    double ratingnumber,String lang
  ) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    DocumentSnapshot<Map<String, dynamic>> data_rating = await FirebaseFirestore
        .instance
        .collection('rating_book')
        .doc(book!.bk_ID)
        .get();
    print(book!.bk_ID);
    Map<String, dynamic>? docData = data_rating.data();
    if (docData != null) {
      List<dynamic> ratingbook = (docData["rating"] as List<dynamic>)
          .map((rating) => Map<String, dynamic>.from(rating))
          .toList();

      ratingbook.add({"ratingnumber": ratingnumber});

      await FirebaseFirestore.instance
          .collection('rating_book')
          .doc(book!.bk_ID)
          .set({
        'username': _auth.currentUser!.displayName ?? "unknown",
        'email': _auth.currentUser!.email ?? "unknown",
        'date': FieldValue.serverTimestamp(),
        'rating': ratingbook,
        'bookId': book!
            .bk_ID, // here will be where all the replies of this post will be in Map...
      });
      Navigator.pop(context);
       await Fluttertoast.showToast(
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 12,
          backgroundColor: ColorLight.primary,
          textColor: Colors.white,
          msg: lang == 'en' ? "successfully rating summaries of book":'تم تقييم ملخصات الكتب بنجاح',
        );
    } else {
      await FirebaseFirestore.instance
          .collection('rating_book')
          .doc(book!.bk_ID)
          .set({
        'username': _auth.currentUser!.displayName ?? "unknown",
        'email': _auth.currentUser!.email ?? "unknown",
        'date': FieldValue.serverTimestamp(),
        'rating': [
          {"ratingnumber": ratingnumber}
        ],
        'bookId': book!
            .bk_ID, // here will be where all the replies of this post will be in Map...
      });
      Navigator.pop(context);
       await Fluttertoast.showToast(
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 12,
          backgroundColor: ColorLight.primary,
          textColor: Colors.white,
          msg:  lang == 'en' ? "successfully rating summaries of book":'تم تقييم ملخصات الكتب بنجاح',
        );
    }
  }

  void favoriteOnTap(Book? book) async {
    SaveFavoriteLocalStorage();
  }

  void orderNowOnTap() {
    Get.toNamed<dynamic>(
      Routes.checkout,
      arguments: Book(
        bk_ID: book!.bk_ID,
        bk_Name: book!.bk_Name,
        imagePath: book!.imagePath,
        price: book!.price! * _sumQuantity,
        tags: book!.tags,
        bk_Introduction: book!.bk_Introduction,
        quantity: _sumQuantity,
        authors: [],
        categories: [],
        genres: [],
        publishers: [],
        thematicAreas: [],
        audioAr: '',
        audioEn: '',
      ),
    );
  }

// ignore: always_declare_return_types, inference_failure_on_function_return_type, non_constant_identifier_names
  SaveFavoriteLocalStorage() async {
    List<dynamic> fav = [];
    var box = await Hive.openBox('favorite');
    var currentfav = box.get('favorite') != null ? box.get('favorite') : null;
    if (currentfav != null) {
      fav = currentfav as List<dynamic>;
      if (_isLiked == true) {
        fav.removeWhere((e) => e.id == book!.bk_ID);
        setState(() {
          _isLiked = false;
        });

        await Fluttertoast.showToast(
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 12,
          backgroundColor: ColorLight.primary,
          textColor: Colors.white,
          msg: AppLocalizations.of(context)!.successfully_remove_from_favorite,
        );
      } else {
        fav.add(
          Favorite(
            id: book!.bk_ID,
            book: book,
            isLiked: true,
          ),
        );

        setState(() {
          _isLiked = true;
        });
        await Fluttertoast.showToast(
          webPosition: 'center',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 12,
          backgroundColor: ColorLight.primary,
          textColor: Colors.white,
          msg: AppLocalizations.of(context)!.successfully_added_to_favorite,
        );
      }
      await addFavorate(boxName: "favorite", favorite: fav);
    } else {
      List<dynamic> newList = [];
      // ignore: cascade_invocations
      newList.add(
        Favorite(
          id: book!.bk_ID!,
          book: book,
          isLiked: true,
        ),
      );

      setState(() {
        _isLiked = true;
      });
      await Fluttertoast.showToast(
        webPosition: 'center',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 12,
        backgroundColor: ColorLight.primary,
        textColor: Colors.white,
        msg: AppLocalizations.of(context)!.successfully_added_to_favorite,
      );
      await addFavorate(boxName: "favorite", favorite: newList);
    }
  }

  Future<void> addFavorate(
      {required String boxName, required List<dynamic> favorite}) async {
    var box = await Hive.openBox(boxName);
    box.put(boxName, favorite);

    print("WALLPAPER ADICIONADO NO HIVE!");
  }
}
