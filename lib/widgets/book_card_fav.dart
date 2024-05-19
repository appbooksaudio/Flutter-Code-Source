import 'package:cached_network_image/cached_network_image.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BookCardFav extends StatelessWidget {
  const BookCardFav({
    required this.book,
    this.isGrid = false,
    super.key,
  });

  final Book? book;
  final bool isGrid;

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    int i = 0;
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => Get.toNamed<dynamic>(Routes.bookdetail,
          arguments: book), //Routes.bookdetail
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
                          ? book!.bk_Name_Ar!
                          : book!.bk_Name!,
                      maxLines: 2,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: book!.authors
                          .map((e) => InkWell(
                                onTap: () {
                                  // authors!.at_Active = e['at_Active'];
                                  //  Get.toNamed(Routes.authors, arguments: authors);
                                },
                                child: Text(
                                  localprovider.localelang!.languageCode == 'ar'
                                      ? e['at_Name_Ar'] + ' & ' as String
                                      : e['at_Name'] + ' & ' as String,
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
                    const SizedBox(height: 12),
                    Text(
                      book!.bk_Language!,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        color: theme.primaryColor,
                        fontSize: 12,
                      ),
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
                    image: CachedNetworkImageProvider(book!.imagePath),
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
