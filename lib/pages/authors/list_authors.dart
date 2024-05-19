import 'package:ejazapp/data/models/authors.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ListAuthors extends StatefulWidget {
  const ListAuthors({super.key});
  @override
  State<ListAuthors> createState() => _ListAuthorsState();
}

class _ListAuthorsState extends State<ListAuthors> {
  var lang = "en";
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  late bool _IsSearching;
  String _searchText = "";
  List<Authors> _searchList = mockAuthors;
  Widget appBarTitleAr = Text(
    "قائمة الكتاب",
    style: TextStyle(color: Colors.white),
  );
  Widget appBarTitle = Text(
    "List of Authors",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = const Icon(
    Icons.search,
    color: ColorLight.primary,
  );

  _ListAuthorsState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
          _buildSearchList();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _IsSearching = false;
    _searchList = mockAuthors;
  }

  @override
  Widget build(BuildContext context) {
    List<Authors> listauthors = [];
    for (int i = 0; i < mockAuthors.length; i++) {
      if (mockAuthors[i].at_Active == true) {
        listauthors.add(mockAuthors[i]);
      }
    }
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    lang = localprovider.localelang!.languageCode;
    return Scaffold(
      key: key,
      appBar: AppBar(
          foregroundColor: themeProv.isDarkTheme! ? Colors.white : Colors.blue,
          backgroundColor:
              themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
          title: localprovider.localelang!.languageCode == 'en'
              ? appBarTitle
              : appBarTitleAr,
          //  style: TextStyle(color: Colors.white)),
          //  Text(localeProv.localelang!.languageCode == 'en'
          //     ? 'List of Authors'
          //     : "قائمة الكتاب"),
          actions: <Widget>[
            IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(
                      Icons.close,
                      color: ColorLight.primary,
                    );
                    localprovider.localelang!.languageCode == 'en'
                        ? this.appBarTitle = TextField(
                            controller: _searchQuery,
                            style: const TextStyle(
                              color: ColorLight.primary,
                            ),
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.search,
                                hintStyle:
                                     TextStyle(color: themeProv.isDarkTheme! ? Colors.white : ColorDark.background)),
                          )
                        : this.appBarTitleAr = TextField(
                            controller: _searchQuery,
                            style: const TextStyle(
                              color: ColorLight.primary,
                            ),
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.search,
                                hintStyle:
                                     TextStyle(color: themeProv.isDarkTheme! ? Colors.white : ColorDark.background)),
                          );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 3 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 20),
            itemCount: _searchList.length,
            itemBuilder: (BuildContext ctx, index) {
              final authors = _searchList[index];
              return InkWell(
                onTap: () =>
                    Get.toNamed<dynamic>(Routes.authors, arguments: authors),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(authors.imagePath),
                      radius: 40,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      localprovider.localelang!.languageCode == 'ar'
                          ? authors.at_Name_Ar
                          : authors.at_Name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = const Icon(
        Icons.search,
        color: ColorLight.primary,
      );
      lang == 'en'
          ? this.appBarTitle = const Text(
              "List Author",
              style: TextStyle(color: Colors.white),
            )
          : this.appBarTitleAr = const Text(
              " قائمة الكتاب",
              style: TextStyle(color: Colors.white),
            );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  List<Authors> _buildList() {
    return mockAuthors; //_list.map((contact) =>  Uiitem(contact)).toList();
  }

  List<Authors> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList =
          mockAuthors; //_list.map((contact) =>  Uiitem(contact)).toList();
    } else {
      _searchList = mockAuthors
          .where((element) => lang == 'en'
              ? element.at_Name
                  .toLowerCase()
                  .contains(_searchText.toLowerCase())
              : element.at_Name_Ar
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()))
          .toList();
      print('${_searchList.length}');
      return _searchList; //_searchList.map((contact) =>  Uiitem(contact)).toList();
    }
  }
}
