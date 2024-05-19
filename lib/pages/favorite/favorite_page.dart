import 'package:ejazapp/data/models/favorite.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:ejazapp/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    initHiveStorage();
    super.initState();
  }

  // ignore: always_declare_return_types, inference_failure_on_function_return_type
  initHiveStorage() async {
    var box = await Hive.openBox('favorite');
    var currentfav = box.get('favorite') != null ? box.get('favorite') : null;
    if (currentfav != null) {
      List<dynamic> Listfav = [];
      Listfav = currentfav as List<dynamic>;
      mockFavoriteList = Listfav.cast<Favorite>();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: NestedScrollView(
          body: mockFavoriteList.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: Const.margin, right: Const.margin),
                        child: Text(
                          AppLocalizations.of(context)!.your_favorite_book,
                          style: theme.textTheme.headlineLarge!.copyWith(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        itemCount: mockFavoriteList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Const.margin,
                          vertical: 15,
                        ),
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final fav = mockFavoriteList[index];
                          return BookVerticalCard(
                            book: fav.book!,
                            file: "",
                          );
                        },
                      ),
                    ],
                  ),
                )
              : EmptyWidget(
                  image: Const.searchfav,
                  title: AppLocalizations.of(context)!.book_shop,
                  subtitle: AppLocalizations.of(context)!
                      .seems_like_you_have_not_have_a_favorite_book_yet,
                  labelButton: AppLocalizations.of(context)!.bowse_ejaz,
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
        ));
  }
}
