import 'dart:developer' as devtools show log;

import 'package:ejazapp/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Const {
  /// [String] Constants
  // C
  static const String cod = 'assets/cod.png';
  // E
  static const String empty = 'assets/empty.png';
  // F
  static const String facebook = 'assets/facebook_sign_in.png';
  // G
  static const String google = 'assets/google.png';
  // I
  static const String illustration1 = 'assets/illustration1.png';
  static const String illustration2 = 'assets/illustration2.png';
  static const String email = 'assets/email.png';
  // L
  static const String localeUS = 'en-US';
  static const String logo = 'assets/logowhite.png';
  static const String logoblue = 'assets/logo.png';
  // M
  static const String mockProfileImage = 'assets/notification.png';
  // O
  static const String onBoardingImage1 = 'assets/onboarding1.json';
  static const String onBoardingImage2 = 'assets/onboarding2.json';
  static const String onBoardingImage3 = 'assets/onboarding3.json';
  //onboarding

  static const String maskgrouphome = 'assets/maskgrouphome.png';
  static const String becomemenber = 'assets/becomemenber.png';
  static const String cardexplore = 'assets/cardexplore.png';
  static const String searchfav = 'assets/searchfavo.json';
  // static const String onBoardingImage2 = 'assets/theosuccess.json';
  // static const String onBoardingImage3 = 'assets/theolistening.json';
  // P
  static const String paypal = 'assets/paypal.png';
  // W
  static const String wallpaper = 'assets/wallpaper.jpg';

  //A
  static const String apple = 'assets/apple.png';
  static const String appleblack = 'assets/appleblack.png';
  //json
  static const String logojsonwhite = 'assets/logojson.json';
  static const String logojsonblue = 'assets/logojsonblue.json';
  static const String logoejaz = 'assets/logoejaz.json';
  static const String logoloding = 'assets/logoloding.json';
  static const String sign = 'assets/siginanimation.json';
  //Book image
  static const String kidsarabic = 'assets/bookimage/kidsarabic.png';
  static const String group = 'assets/maskgroup.png';
  //api image
  static const String server = 'assets/server.json';
  static const String loading = 'assets/loading.json';
  static const String offline = 'assets/offline.json';
  static const String nodata = 'assets/nodata.json';
  static const String list = 'assets/list.json';
  static const String notification = 'assets/notification.png';
  static const String flagqatar = 'assets/qatarflag.jpeg';
  static const String flagenglish = 'assets/flagenglish.png';
  static const String blocked = 'assets/blocked.png';
  static const String tranparent = 'assets/transparent.png';
  static const String backpopup = 'assets/backpopup.json';
  static const String bookpopup = 'assets/bookpopup.png';
  static const String notificationsstate = 'assets/notificationsstate.json';
  static const String takeway = 'assets/takeway.json';
  static const String avatar = 'assets/avatar.png';
  static const String avatar1 = 'assets/avatar1.png';
  static const String noarrival =
      "https://cdn2.vectorstock.com/i/1000x1000/04/26/no-data-empty-concept-vector-41830426.jpg";
  static const String UrlAu =
      'https://ejaz.applab.qa/api/ejaz/v1/Medium/getAudio/00000000-0000-0000-0000-000000000000';

  // Double
  static const double margin = 18;
  static const double radius = 8;
}

Future<dynamic> showToast({
  required String msg,
  Color? backgroundColor,
  Color? textColor,
}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    fontSize: 16,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.grey.withOpacity(.5),
    textColor: ColorLight.fontTitle,
  );
}

void showSnackBar(
  String text, {
  Duration duration = const Duration(seconds: 2),
}) {
  // Globals.scaffoldMessengerKey.currentState
  //   ?..clearSnackBars()
  //   ..showSnackBar(
  //     SnackBar(content: Text(text), duration: duration),
  //   );
}

bool isNullOrBlank(String? data) => data?.trim().isEmpty ?? true;

void log(
  String screenId, {
  dynamic msg,
  dynamic error,
  StackTrace? stackTrace,
}) =>
    devtools.log(
      msg.toString(),
      error: error,
      name: screenId,
      stackTrace: stackTrace,
    );
