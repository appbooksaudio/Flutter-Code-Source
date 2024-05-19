import 'package:cached_network_image/cached_network_image.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/data/models/collections.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with SingleTickerProviderStateMixin {
  List<Book>? book;
  Collections? collection;
  List<Book> collectionByIdList = [];
  @override
  void initState() {
    book = Get.arguments as List<Book>;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < book!.length; i++) {
      if (book!.length > 0) {
        collectionByIdList.add(mockBookList
            .where((element) => element.bk_ID == book![i].bk_ID)
            .first);
      }
    }

    int numbook = collectionByIdList.length;
    final themeProv = Provider.of<ThemeProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    final localeProv = Provider.of<LocaleProvider>(context);
    final heigth = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:themeProv.isDarkTheme!
                ?ColorDark.background: ColorLight.primary,
      appBar: AppBar(
        backgroundColor: themeProv.isDarkTheme!
            ? ColorDark.background
            : ColorLight.primary, //theme.colorScheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Get.back<dynamic>(),
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: themeProv.isDarkTheme!
                ? ColorDark.background
                : ColorLight.primary,
            height: heigth * 0.23,
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: OctoImage(
                        alignment: Alignment.topLeft,
                        image: CachedNetworkImageProvider(book![0].imagePath),
                        fit: BoxFit.contain,
                        height: 80,
                        errorBuilder: OctoError.icon(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                     SizedBox(height: heigth * 0.03),
                    Expanded(
                        child: Text(
                      localeProv.localelang!.languageCode == 'ar'
                          ? book![0].bk_Name_Ar!
                          : book![0].bk_Name!,
                      style: theme.textTheme.headlineLarge!.copyWith(
                          color: Colors.white, fontSize: 25, height: 1.2),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    )),
                 
                  ],
                )),
          ),
              SizedBox(height: heigth * 0.01),
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: themeProv.isDarkTheme!
                ? ColorDark.background
                : ColorLight.primary,
            child: Container(
              decoration: BoxDecoration(
                  color: themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
              child: Column(children: [
                buildSettingApp(
                  context,
                  title: localeProv.localelang!.languageCode == 'en'
                      ? "Showing" + " $numbook " + "Titles"
                      : "عرض" + " $numbook " + "عنوان ",
                  style: theme.textTheme.headlineMedium!.copyWith(
                      fontSize: 17,
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black),
                  trailing: const Text(""),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // crossAxisSpacing: 5,
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 3 : 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height),
                    ),
                    itemCount: collectionByIdList.length,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        left: Const.margin, right: Const.margin),
                    itemBuilder: (context, index) {
                      final Book book1;
                      book1 = collectionByIdList[index];
                      return BookCardDetailsCategory(book: book1);
                    }),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

InkWell buildSettingApp(
  BuildContext context, {
  required String title,
  TextStyle? style,
  IconData? icon,
  Widget? trailing,
  void Function()? onTap,
}) {
  final themeProv = Provider.of<ThemeProvider>(context);
  final theme = Theme.of(context);
  return InkWell(
    onTap: onTap,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
        ),
        // const SizedBox(width: 15),
        Expanded(
            child: Text(
          title,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: themeProv.isDarkTheme! ? Colors.white : ColorDark.background,
          ),
        )),
        trailing!,
      ],
    ),
  );
}
