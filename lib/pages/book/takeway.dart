import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class takeway extends StatefulWidget {
  const takeway({super.key});

  @override
  State<takeway> createState() => _takewayState();
}

class _takewayState extends State<takeway> {
  Book? book;
  String LanguageStatus = "en";
  @override
  void initState() {
    super.initState();
    book = Get.arguments[0] as Book;
    LanguageStatus = Get.arguments[1] as String;
  }

  @override
  Widget build(BuildContext context) {
    List singletakeway = [];
    List singletakewayAr = [];
    List<Book> listTakeway = [];

    for (var i = 0; i < mockBookList.length; i++) {
      if (mockBookList[i].categories.length > 0) {
        if (mockBookList[i].categories[0]['ct_Name'] != 'Novels' &&
            mockBookList[i].bk_ID == book!.bk_ID) {
          listTakeway.add((mockBookList[i]));

          List takrabic = mockBookList[i].bk_Characters_Ar!.split('\n\n');
          for (var i = 0; i < takrabic.length; i++) {
            singletakewayAr.add(takrabic[i]);
          }

          List takrenglish = mockBookList[i].bk_Characters!.split('\n\n');
          for (var i = 0; i < takrenglish.length; i++) {
            singletakeway.add(takrenglish[i]);
          }
        }
      }
    }

    print('values    ${singletakeway.length}');
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Scaffold(
        backgroundColor:
            themeProv.isDarkTheme! ? ColorDark.background : Color(0xFFdde3f9),
        body: NestedScrollView(
          body: (localprovider.localelang!.languageCode == 'en'
                  ? singletakeway.isNotEmpty
                  : singletakewayAr.isNotEmpty)
              ? (localprovider.localelang!.languageCode == 'en'
                      ? singletakeway[0] != 'N/A'
                      : singletakewayAr[0] != 'N/A')
                  ? Stack(
                      textDirection: LanguageStatus == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30.0, right: 30, top: 0),
                          child: Text(
                            LanguageStatus == 'en' ? "Takeaway" : "بإيجاز",
                            //AppLocalizations.of(context)!.takeaway,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: themeProv.isDarkTheme!
                                    ? Colors.white
                                    : ColorDark.background),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.separated(
                            itemCount: LanguageStatus ==
                                    'ar' //localprovider.localelang!.languageCode
                                ? singletakewayAr.length
                                : singletakeway.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  textColor: themeProv.isDarkTheme!
                                      ? Colors.white
                                      : ColorDark.background,
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      textDirection: LanguageStatus == 'ar'
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Text(
                                              textAlign: LanguageStatus == 'ar'
                                                  ? TextAlign.center
                                                  : TextAlign.center,
                                              localprovider.localelang!
                                                          .languageCode ==
                                                      'en'
                                                  ? '${index + 1}' //singletakewayAr[index].toString().substring(0, 2)
                                                  : '${index + 1} ',
                                              style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: Text(
                                              textDirection:
                                                  LanguageStatus == 'ar'
                                                      ? TextDirection.rtl
                                                      : TextDirection.ltr,
                                              LanguageStatus == 'ar'
                                                  ? '${singletakewayAr[index].toString().substring(3, singletakewayAr[index].toString().length)}'
                                                  : '${singletakeway[index].toString().substring(3, singletakeway[index].toString().length)}',
                                              style: const TextStyle(
                                                  fontSize: 13, height: 1.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 2,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: EmptyWidget(
                        image: Const.takeway,
                        title: AppLocalizations.of(context)!.take_title,
                        subtitle: AppLocalizations.of(context)!.take_subtile,
                      ),
                    )
              : Center(
                  child: EmptyWidget(
                    image: Const.takeway,
                    title: AppLocalizations.of(context)!.take_title,
                    subtitle: AppLocalizations.of(context)!.take_subtile,
                  ),
                ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: OutlinedButton.icon(
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
                            themeProv.isDarkTheme!
                                ? ColorDark.background
                                : Colors.transparent,
                          ),
                        ),
                            icon: const Icon(Icons.language, size: 30),
                        label: Text('')
                        // Text(
                        //   LanguageStatus == 'ar' ? "En" : "ع",
                        //   style: LanguageStatus == 'ar'
                        //       ? TextStyle(
                        //           fontSize: 18, fontWeight: FontWeight.bold)
                        //       : TextStyle(
                        //           fontSize: 20, fontWeight: FontWeight.bold),
                        // ),
                      ),
                    ),
                  ],
                  backgroundColor: themeProv.isDarkTheme!
                      ? ColorDark.background
                      : Color(0xFFdde3f9),
                  foregroundColor:
                      themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
                  pinned: true,
                  centerTitle: true,
                  automaticallyImplyLeading: true),
            ];
          },
        ));
  }
}
