import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/helpers/theme.dart';
import 'package:ejazapp/helpers/themear.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerLang extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();
  ThemeData appTheme = themeLight;
  ThemeData appThemedark = themeDark;

  ChangeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.prefs.setString('lang', langcode);

    mybox!.put('lang', langcode);
    appTheme = langcode == "ar" ? themeLightAr : themeLight;
    appThemedark = langcode == "ar" ? themeDarkAr : themeDark;
    Get.changeTheme(appTheme);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    String? sharedPrefLang = myServices.prefs.getString('lang');
    if (sharedPrefLang == 'ar') {
      language = const Locale('ar');
      appTheme = themeLightAr;
      appThemedark = themeDarkAr;
    } else if (sharedPrefLang == 'en') {
      language = const Locale('en');
      appTheme = themeLight;
      appThemedark = themeDark;
    } else {
      language = const Locale('en'); //Get.deviceLocale!.languageCode
      appTheme = themeLight;
      appThemedark = themeDark;
    }
    super.onInit();
  }
}
