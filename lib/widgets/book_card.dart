import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/data/models/authors.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/data/models/category.dart';
import 'package:ejazapp/data/models/collections.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


var lang = mybox!.get('lang');

class BookCard extends StatelessWidget {
  const BookCard({
    required this.book,
    this.isGrid = false,
    super.key,
  });

  final Book? book;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final bookstate = book!.bk_trial!;
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    String Lang = localprovider.localelang!.languageCode;
    return Padding(
      padding: EdgeInsets.only(right: isGrid ? 0.0 : 15.0),
      child: InkWell(
        onTap: () {
          if (book!.bk_trial! != true) {
            Get.toNamed<dynamic>(Routes.selectplan);
            // PaymentDo(context);
            return;
          }
          Get.toNamed<dynamic>(Routes.bookdetail, arguments: [book, "", Lang]);
        }, //Routes.bookdetail
        borderRadius: BorderRadius.circular(15),
        child: Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: bookstate != true
                ? themeProv.isDarkTheme!
                    ? ColorDark.card.withOpacity(0.0)
                    : Colors.white.withOpacity(0.5)
                : Colors.transparent,
            image: DecorationImage(
              alignment: const Alignment(-0.0, -0.4),
              scale: 2.5,
              image: bookstate != true
                  ? const AssetImage(Const.blocked)
                  : const AssetImage(Const.tranparent),

              // fit: BoxFit.contain,
            ),
          ),
          child: SizedBox(
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // buildBodyCard(context),
                buildImage(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned buildImage(BuildContext context) {
    final theme = Theme.of(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Positioned(
        top: 0,
        left: 5,
        right: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: OctoImage(
                image: CachedNetworkImageProvider(book!.imagePath),
                fit: BoxFit.contain,
                width: 110,
                errorBuilder: OctoError.icon(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              // ignore: unrelated_type_equality_checks
              localprovider.localelang!.languageCode == 'ar'
                  ? book!.bk_Name_Ar!
                  : book!.bk_Name!,
              style: theme.textTheme.bodyMedium!
                  .copyWith(height: 1.3, fontSize: 12),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            const SizedBox(height: 1),
            Wrap(
              runSpacing: 1,
              children: book!.authors
                  .asMap()
                  .map((i, e) => MapEntry(
                        i,
                        Text(
                          e['at_Name'] == "N/A"
                              ? e['at_Name_Ar'] as String
                              : localprovider.localelang!.languageCode == 'ar'
                                  ? i < book!.authors.length - 1 == true
                                      ? e['at_Name_Ar'] + ' و ' as String
                                      : e['at_Name_Ar'] + ' ' as String
                                  : i < book!.authors.length - 1 == true
                                      ? e['at_Name'] + ' & ' as String
                                      : e['at_Name'] + ' ' as String,
                          style: theme.textTheme.bodyMedium!
                              .copyWith(height: 1.1, fontSize: 11)
                              .copyWith(color: Colors.lightBlue),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                      ))
                  .values
                  .toList(),
            ),
            const SizedBox(height: 1),
            Row(
              children: [
                const Icon(
                  Feather.globe,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: localprovider.localelang!.languageCode == 'en'
                      ? const EdgeInsets.only(top: 8.0)
                      : EdgeInsets.all(0),
                  child: Text(
                    localprovider.localelang!.languageCode == 'en'
                        ? book!.bk_Language!
                        : book!.bk_Language_Ar!,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: Colors.blueGrey),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Positioned buildBodyCard(BuildContext context) {
    final theme = Theme.of(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      top: 200,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 85),
              Text(
                localprovider.localelang!.languageCode == 'ar'
                    ? book!.bk_Name_Ar!
                    : book!.bk_Name!,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 15),
              // Text(
              //   NumberFormat.currency(
              //     symbol: r'QAR',
              //     decimalDigits: 0,
              //     locale: Const.localeUS,
              //   ).format(book!.price),
              //   overflow: TextOverflow.clip,
              //   textAlign: TextAlign.left,
              //   style: theme.textTheme.headlineLarge!
              //       .copyWith(color: theme.primaryColor),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookVerticalCard extends StatelessWidget {
  const BookVerticalCard({
    required this.book,
    required this.file,
    super.key,
  });

  final Book book;
  final String file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    String Lang = localprovider.localelang!.languageCode;
    int i = 0;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => Get.toNamed<dynamic>(Routes.bookdetail,
          arguments: [book, file, Lang]), //Routes.bookdetail
      child: Card(
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 1,
        child: Container(
          width: double.infinity,
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: Const.margin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localprovider.localelang!.languageCode == 'ar'
                          ? book.bk_Name_Ar!
                          : book.bk_Name!,
                      maxLines: 3,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        height: 1,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: book.authors
                          .map((e) => InkWell(
                                onTap: () {
                                  // authors!.at_Active = e['at_Active'];
                                  //  Get.toNamed(Routes.authors, arguments: authors);
                                },
                                child: Text(
                                  e['at_Name'] == "N/A"
                                      ? e['at_Name_Ar'] as String
                                      : (localprovider
                                                  .localelang!.languageCode ==
                                              'ar'
                                          ? i < book!.authors.length - 1 == true
                                              ? e['at_Name_Ar'] + ' و '
                                                  as String
                                              : e['at_Name_Ar'] + ' ' as String
                                          : i < book!.authors.length - 1 == true
                                              ? e['at_Name'] + ' & ' as String
                                              : e['at_Name'] + ' ' as String),
                                  // localprovider
                                  //           .localelang!.languageCode ==
                                  //       'ar'
                                  //   ? e['at_Name_Ar'] + ' & ' as String
                                  //   : e['at_Name'] + ' & ' as String),
                                  style: theme.textTheme.bodyMedium!
                                      .copyWith(
                                        height: 1.5,
                                      )
                                      .copyWith(color: Colors.lightBlue),
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          book.bk_Language!,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.left,
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: const Icon(
                        //       Icons.delete,
                        //       color: Colors.red,
                        //     ))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Container(
                width: 70.0,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(book.imagePath),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupBookVerticalCard extends StatelessWidget {
  const GroupBookVerticalCard({
    required this.collection,
    this.isGrid = false,
    super.key,
  });

  final Collections? collection;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(right: isGrid ? 0.0 : 15.0),
      child: InkWell(
        onTap: () {
          BooksApi().GetEjazCollectionById(collection!.bc_ID);
        },
        //  Get.toNamed<dynamic>('', arguments: collection), //Routes.bookdetail
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          child: Stack(
            children: [
              // buildBodyCard(context),
              SizedBox(
                width: 240,
                height: 280,
                child: Card(
                  color: themeProv.isDarkTheme!
                      ? Color.fromARGB(255, 37, 46, 68)
                      : Colors.white,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 1,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 10),
                        width: 270,
                        height: 215,
                        child: Container(
                          //  padding: const EdgeInsets.all(8),
                          // color: Colors.teal[200],
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: OctoImage(
                              image: CachedNetworkImageProvider(
                                  collection!.imagePath!),
                              fit: BoxFit.cover,
                              errorBuilder: OctoError.icon(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          localprovider.localelang!.languageCode == 'en'
                              ? collection!.bc_Title
                              : collection!.bc_Title_Ar,
                          maxLines: 2,
                          style: theme.textTheme.headlineLarge!
                              .copyWith(height: 1, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PopularVerticalCard extends StatelessWidget {
  const PopularVerticalCard({
    required this.book,
    this.isGrid = false,
    super.key,
  });

  final Book? book;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(right: isGrid ? 0.0 : 15.0),
      child: InkWell(
        onTap: () =>
            Get.toNamed<dynamic>('', arguments: book), //Routes.bookdetail
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          child: Stack(
            children: [
              // buildBodyCard(context),
              Container(
                width: 300,
                height: 300,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        width: 300,
                        height: 200,
                        child: Image.asset(
                          Const.illustration2,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Boosting Perfeormance At Work place',
                          maxLines: 2,
                          style: theme.textTheme.headlineLarge!
                              .copyWith(height: 1, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BookCardCategory extends StatelessWidget {
  const BookCardCategory({
    required this.category,
    this.isGrid = false,
    super.key,
  });

  final CategoryL? category;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isGrid ? 0.0 : 15.0),
      child: InkWell(
        onTap: () => Get.toNamed<dynamic>(Routes.category, arguments: category),
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 80,
          child: Stack(
            children: [
              // buildBodyCard(context),
              buildImage(context),
            ],
          ),
        ),
      ),
    );
  }

  Positioned buildImage(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: OctoImage(
                image: CachedNetworkImageProvider(
                  category!.imagePath,
                ),
                fit: BoxFit.contain,
                width: 120,
                errorBuilder: OctoError.icon(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              localeProv.localelang!.languageCode == 'ar'
                  ? category!.ct_Name_Ar
                  : category!.ct_Name,
              style: theme.textTheme.headlineSmall!.copyWith(
                  fontSize: 12,
                  height: 1,
                  color:
                      themeProv.isDarkTheme! ? Colors.white : Colors.black54),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
          ]),
    );
  }
}

class BookCardDetailsCategory extends StatefulWidget {
  const BookCardDetailsCategory({
    required this.book,
    this.isGrid = false,
    super.key,
  });

  final Book? book;
  final bool isGrid;

  @override
  State<BookCardDetailsCategory> createState() =>
      _BookCardDetailsCategoryState();
}

class _BookCardDetailsCategoryState extends State<BookCardDetailsCategory> {
  bool? _isIpad;

  @override
  void initState() {
    super.initState();
    isIpad();
  }

  Future<bool> isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name != null) if (info.name!.toLowerCase().contains("ipad")) {
      setState(() {
        _isIpad = true;
      });
      return true;
    }
    setState(() {
      _isIpad = false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bookstate = widget.book!.bk_trial!;
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    String Lang = localprovider.localelang!.languageCode;
    return Padding(
        padding: EdgeInsets.only(right: widget.isGrid ? 0.0 : 15.0),
        child: InkWell(
            onTap: () {
              if (widget.book!.bk_trial! != true) {
                Get.toNamed<dynamic>(Routes.selectplan);
                // PaymentDo(context);
                return;
              }
              Get.toNamed<dynamic>(Routes.bookdetail,
                  arguments: [widget.book, "", Lang]);
            }, //Routes.bookdetail
            borderRadius: BorderRadius.circular(15),
            child: SingleChildScrollView(
              child: Container(
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: bookstate != true
                      ? themeProv.isDarkTheme!
                          ? ColorDark.card.withOpacity(0.0)
                          : Colors.white.withOpacity(0.0)
                      : Colors.transparent,
                  image: DecorationImage(
                    alignment: const Alignment(0.0, -0.4),
                    scale: 2.5,
                    image: bookstate != true
                        ? const AssetImage(Const.blocked)
                        : const AssetImage(Const.tranparent),

                    // fit: BoxFit.contain,
                  ),
                ),
                child: Stack(
                  children: [
                    // buildBodyCard(context),
                    buildImage(context),
                  ],
                ),
              ),
            )));
  }

  Positioned buildImage(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final theme = Theme.of(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Positioned(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child:
           OctoImage(
            width: width * 1,
            height: height * 0.19,
            image: CachedNetworkImageProvider(
              widget.book!.imagePath,
            ),
            memCacheWidth: 160,
            memCacheHeight: 250,
            fit: _isIpad == false ? BoxFit.cover : BoxFit.contain,
            placeholderBuilder: OctoPlaceholder.circularProgressIndicator(),
            errorBuilder: OctoError.icon(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: Text(
            localprovider.localelang!.languageCode == 'ar'
                ? widget.book!.bk_Name_Ar!
                : widget.book!.bk_Name!,
            style:
                theme.textTheme.bodyMedium!.copyWith(height: 1.3, fontSize: 12),
            textAlign: _isIpad == false ? TextAlign.start : TextAlign.center,
            maxLines: 1,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Wrap(
          runSpacing: 1,
          children: widget.book!.authors
              .asMap()
              .map((i, e) => MapEntry(
                    i,
                    Container(
                      width: double.infinity,
                      child: Text(
                        localprovider.localelang!.languageCode == 'ar'
                            ? i < widget.book!.authors.length - 1 == true
                                ? e['at_Name_Ar'] + ' و ' as String
                                : e['at_Name_Ar'] + ' ' as String
                            : i < widget.book!.authors.length - 1 == true
                                ? e['at_Name'] + ' & ' as String
                                : e['at_Name'] + ' ' as String,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(height: 1.5, fontSize: 11)
                            .copyWith(color: Colors.lightBlue),
                        textAlign: _isIpad == false
                            ? TextAlign.start
                            : TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
      ],
    ));
  }
}

class AuthorsCard extends StatelessWidget {
  const AuthorsCard({
    required this.authors,
    this.isGrid = false,
    super.key,
  });

  final Authors? authors;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isGrid ? 0.0 : 15.0),
      child: InkWell(
        onTap: () => Get.toNamed<dynamic>(Routes.authors,
            arguments: authors), //Routes.bookdetail
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 200,
          width: 90,
          child: Stack(
            children: [
              // buildBodyCard(context),

              buildImage(context),
            ],
          ),
        ),
      ),
    );
  }

  Positioned buildImage(BuildContext context) {
    final theme = Theme.of(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: OctoImage(
                image: CachedNetworkImageProvider(authors!.imagePath),
                fit: BoxFit.fill,
                width: 80,
                height: 80,
                errorBuilder: OctoError.icon(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              localprovider.localelang!.languageCode == 'ar'
                  ? authors!.at_Name_Ar
                  : authors!.at_Name == "N/A"
                      ? authors!.at_Name_Ar
                      : authors!.at_Name,
              style: theme.textTheme.headlineSmall!
                  .copyWith(fontSize: 12, height: 1.5),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
            const SizedBox(height: 5),
            // MyRaisedButton(
            //   color: Color.fromARGB(255, 57, 154, 251),
            //   //  width: 50,
            //   height: 30,
            //   onTap: OpenApp,
            //   label: AppLocalizations.of(context)!.follow,
            // ),
          ],
        ));
  }
}

OpenApp() async {
  final name = mybox!.get('name');
  if (name == 'Guest') {
    Get.showSnackbar(GetSnackBar(
      title: 'Ejaz',
      message:
          AppLocalizations.of(Get.context as BuildContext)!.messagetoguestuser,
      duration: const Duration(seconds: 5),
      titleText: Column(
        children: [],
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.login),
    ));
    return;
  }
  Get.toNamed(Routes.suggesttejaz);
  // final Uri url = Uri.parse('https://getejaz.com/pages/suggest-book');
  // if (!await launchUrl(url)) {
  //   throw Exception('Could not launch $url');
  // }
}

getCollectionbyID(String id) {}
