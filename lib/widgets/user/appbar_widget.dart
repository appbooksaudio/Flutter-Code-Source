import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppBar buildAppBar(BuildContext context) {
  final icon = CupertinoIcons.moon_stars;
  final themeProv = Provider.of<ThemeProvider>(context);
  return AppBar(
    foregroundColor: themeProv.isDarkTheme! ? Colors.white : Colors.blue,
    backgroundColor: themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
    leading: BackButton(),
    elevation: 0,
    actions: [
      // IconButton(
      //   icon: Icon(icon),
      //   onPressed: () {},
      // ),
    ],
  );
}
