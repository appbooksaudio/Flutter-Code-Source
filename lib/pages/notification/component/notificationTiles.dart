import 'dart:core';

import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationTiles extends StatelessWidget {
  final String title, subtitle, date;
  final void Function() onTap;
  final bool enable;
  const NotificationTiles({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.onTap,
    required this.enable,
  });

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: Container(
          height: 60.0,
          width: 50.0,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              color: themeProv.isDarkTheme! ? Colors.white : Colors.transparent,
              image: const DecorationImage(
                image: AssetImage(
                  Const.notification,
                ),
                fit: BoxFit.scaleDown,
              ))),
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(title,
            style: TextStyle(
                color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20)),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: themeProv.isDarkTheme! ? Colors.white : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(""),
              Text(
                date,
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          )
        ],
      ),
      onTap: onTap,
      enabled: enable,
    );
  }
}
