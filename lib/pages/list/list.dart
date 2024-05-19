import 'dart:io';

import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/pages/book/audio_book/audiobookitem.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:ejazapp/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

List<dynamic> Listdownload = [];

class ListBook extends StatefulWidget {
  const ListBook({super.key});

  @override
  State<ListBook> createState() => _ListBookState();
}

class _ListBookState extends State<ListBook> {
  List<String> Audio = [];
  Directory? directory;

  @override
  void initState() {
    // TODO: implement initState
    getDownloadPath();
    getMydownloadBook(boxName: "Listbookdownloads1");
    super.initState();
  }

  Future<String?>? getDownloadPath() async {
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        print('ios directory $directory');
      } else {
        directory = Directory('/storage/emulated/0/Download');

        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory!.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }

    directory!.listSync(recursive: true).forEach((e) {
      String value = e.toString();
      if (value.contains('.mp3')) Audio.add(value);
    });
    setState(() {});

    return directory!.path;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    late File file = new File('');
    String idBook = "";

    return Scaffold(
        backgroundColor:
            themeProv.isDarkTheme! ? ColorDark.background : Colors.white,
        body: NestedScrollView(
          body: Listdownload.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: Const.margin, right: Const.margin),
                      child: Text(
                        AppLocalizations.of(context)!.your_download_book,
                        style: theme.textTheme.headlineLarge!.copyWith(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      itemCount: Listdownload.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Const.margin,
                        vertical: 15,
                      ),
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        final book = Listdownload[index];
                        for (var i = 0; i < Audio.length; i++) {
                          if (Platform.isIOS) {
                            idBook = Audio[i].split('Documents/')[1];
                            print("id book $idBook");
                            idBook = idBook.split('.')[0];
                            print("id book $idBook");
                            if (idBook == book.bk_ID) {
                              file = File(Audio[i]
                                  .split('File: ')[1]
                                  .replaceAll("'", ""));
                            }
                          } else {
                            idBook = Audio[i].split('Download/')[1];
                            print("id book $idBook");
                            idBook = idBook.split('.')[0];
                            print("id book $idBook");
                            if (idBook == book.bk_ID) {
                              file = File(Audio[i]
                                  .split('File: ')[1]
                                  .replaceAll("'", ""));
                            }
                          }
                        }
                        return Stack(
                          children: [
                            BookVerticalCard(
                                book: book as Book,
                                file: file != '' ? file.path : ''),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.08),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(''),
                                  Text(''),
                                  IconButton(
                                      onPressed: () {
                                        Listdownload.removeWhere(
                                            (item) => item.bk_ID == book.bk_ID);
                                        setState(() {});
                                        addBook(
                                            books: Listdownload,
                                            boxName: 'Listbookdownloads1');
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  Text(''),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                )
              : EmptyWidget(
                  image: Const.searchfav,
                  title: AppLocalizations.of(context)!.no_book,
                  subtitle: AppLocalizations.of(context)!
                      .download_books_willapear_here,
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

  getMydownloadBook({required String boxName}) async {
    var box = await Hive.openBox('Listbookdownloads1');
    var ListDownload2 = box.get('Listbookdownloads1') != null
        ? box.get('Listbookdownloads1')
        : null;
    if (ListDownload2 != null) {
      Listdownload = ListDownload2 as List<dynamic>;
      setState(() {});
      return Listdownload;
    }
  }
}
