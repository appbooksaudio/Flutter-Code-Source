import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleProvider with ChangeNotifier {
  Locale? localelang;
  Locale? get locale => localelang;
  set locale(Locale? val) {
    localelang = val;
    notifyListeners();
  }

  void setLocale(Locale? locale) async {
    if (!L10n.all.contains(locale)) return;
    localelang = locale;
    notifyListeners();
  }

  void clearLocale() {
    localelang = null;
    notifyListeners();
  }

  initState() {
    MyServices myServices = Get.find();
    String? sharedPrefLang = myServices.prefs.getString('lang');
    if (sharedPrefLang == 'ar') {
      localelang = const Locale('ar');
    } else if (sharedPrefLang == 'en') {
      localelang = const Locale('en');
    } else {
      localelang = const Locale('en'); //Get.deviceLocale!.languageCode
    }
  }
}
