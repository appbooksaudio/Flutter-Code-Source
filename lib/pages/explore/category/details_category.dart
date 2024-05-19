import 'package:cached_network_image/cached_network_image.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/data/models/category.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  CategoryL? category;
  @override
  void initState() {
    category = Get.arguments as CategoryL;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Book> CatBook = [];
    for (var i = 0; i < mockBookList.length; i++) {
      if (mockBookList[i].categories.isNotEmpty)
      // ignore: avoid_dynamic_calls, curly_braces_in_flow_control_structures
      if (mockBookList[i].categories[0]['ct_ID'] == category!.ct_ID) {
        CatBook.add(mockBookList[i]);
      }
    }

    int numbook = CatBook.length;
    final themeProv = Provider.of<ThemeProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    final localeProv = Provider.of<LocaleProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: themeProv.isDarkTheme!
            ? ColorDark.background
            : ColorLight.primary, 
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
            height: 210,
            child: Padding(
                padding: const EdgeInsets.all(30),
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
                        image: CachedNetworkImageProvider(category!.imagePath),
                        fit: BoxFit.contain,
                        height: 80,
                        errorBuilder: OctoError.icon(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                        child: Text(
                      localeProv.localelang!.languageCode == 'ar'
                          ? category!.ct_Name_Ar
                          : category!.ct_Name,
                      style: theme.textTheme.headlineLarge!.copyWith(
                          color: Colors.white, fontSize: 25, height: 1.2),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    )),
                    const SizedBox(height: 12),
                  ],
                )),
          ),
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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: ListView(children: [
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
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 3 : 3,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height),
                    ),
                    itemCount: CatBook.length,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        left: Const.margin, right: Const.margin),
                    itemBuilder: (context, index) {
                      final Book book;

                      book = CatBook[index];
                      return BookCardDetailsCategory(book: book);
                    }),
                SizedBox(
                  height: 300,
                )
              ]),
            ),
          ),
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
