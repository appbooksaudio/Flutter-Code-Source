import 'package:date_format/date_format.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AllItem extends StatefulWidget {
  const AllItem({super.key});

  @override
  State<AllItem> createState() => _AllItemState();
}

class _AllItemState extends State<AllItem> {
  List<Book>? currentList = [];
  String namePage = "";
  String homeindex = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      currentList =
          Get.arguments[0] != "" ? Get.arguments[0] as List<Book> : null;
      namePage = Get.arguments[1] as String;
      homeindex = Get.arguments[2] != null ? Get.arguments[2] as String : "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final themeProv = Provider.of<ThemeProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    final localeProv = Provider.of<LocaleProvider>(context);
    final theme = Theme.of(context);
    //***************** Start insert list of new books to array list     *********************//
    List<Book> ListCat = [];
    if (homeindex != "") {
      for (var i = 0; i < mockBookList.length; i++) {
        if (mockBookList[i].categories.isNotEmpty) {
          if (mockBookList[i].categories[0]['ct_Name'] == homeindex) {
            ListCat.add(mockBookList[i]);
          } else if (homeindex == 'newejaz') {
            var formattedDate2 = formatDate(lastWeek, [yyyy, '-', mm, '-', dd]);
            var datebook =
                mockBookList[i].bk_CreatedOn!.toString().replaceAll("T", " ");

            var dateBookC = DateTime.parse(datebook);
            var formattedDate1 =
                formatDate(dateBookC, [yyyy, '-', mm, '-', dd]);
            print("formattedDate1    $formattedDate1");
            if ((DateTime.parse(formattedDate1))
                    .compareTo(DateTime.parse(formattedDate2)) >
                0) {
              ListCat.add(mockBookList[i]);
            }
          }
        }
      }
    }
    //***************** End insert list of new books to array list     *********************//
    //***************** Start  calcul number of book     *********************//
    var numbook = namePage == 'explore'
        ? currentList!.length
        : ListCat.isEmpty
            ? mockBookList.length
            : ListCat.length;
    //***************** End  calcul number of book     *********************//
    return Scaffold(
        body: NestedScrollView(
      body: namePage == 'lastbook' || namePage == 'explore'
          ? SingleChildScrollView(
              child: Column(
              children: [
                const SizedBox(height: 10),
                buildSettingApp(
                  context,
                  title: localeProv.localelang!.languageCode == 'en'
                      ? "Showing" + " $numbook " + "books"
                      : "عرض" + " $numbook " + "كتب ",
                  style: theme.textTheme.headlineLarge!.copyWith(fontSize: 17),
                  // trailing: const Icon(Feather.grid, color: ColorLight.primary),
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                   mainAxisExtent: height * 0.30,
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 3 : 6,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height),
                  ),
                  itemCount: namePage == 'explore'
                      ? currentList!.length
                      : ListCat.isEmpty
                          ? mockBookList.length
                          : ListCat.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: Const.margin),
                  itemBuilder: (context, index) {
                    final book = namePage == 'explore'
                        ? currentList![index]
                        : ListCat.isEmpty
                            ? mockBookList[index]
                            : ListCat[index];

                    return BookCardDetailsCategory(book: book);
                  },
                ),
              ],
            ))
          : const Center(
              child: Text(
              'No Books added For Last Week on Ejaz',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )),
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
    ));
  }

  InkWell buildSettingApp(
    BuildContext context, {
    required String title,
    TextStyle? style,
    IconData? icon,
    //  Widget? trailing,
    void Function()? onTap,
  }) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
                  color: themeProv.isDarkTheme!
                      ? ColorLight.background
                      : ColorDark.background,
                  fontWeight: FontWeight.bold),
            )),
            //  trailing!,
          ],
        ),
      ),
    );
  }
}
