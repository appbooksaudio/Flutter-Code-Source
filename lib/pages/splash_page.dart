import 'dart:async';

import 'package:ejazapp/data/datasource/remote/firebaseapi/updatetoken.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SharedPreferences sharedPreferences;
  bool startedPlaying = false;
  void startSplashScreen() {
    Timer(const Duration(seconds: 3), navigateToNextScreen);
  }

  void navigateToNextScreen() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString("token"));
    if (sharedPreferences.getString("token") == null ||
        sharedPreferences.getString("token") == "") {
      Get.offAllNamed<dynamic>(Routes.changeLanguage); //onboarding
    } else {
      try {
        await FirebaseMessaging.instance.getToken().then((value) {
          print(value);
          String? token = value;
          print("Token             $token");
          UpdateFirebaseToken(token!);
        });
        Get.offAllNamed<dynamic>(Routes.home);
      } catch (e) {
        Get.offAllNamed<dynamic>(Routes.home);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();

    getCurrentTheme();
    context.read<LocaleProvider>().initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0088CE),
      body: Center(
        child: Lottie.asset(
          Const.logoejaz,
          width: 350,
          height: 350,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Future<dynamic> getCurrentTheme() async {
    final themeProv = Provider.of<ThemeProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getBool('darkTheme');

    themeProv.isDarkTheme = theme;
    themeProv.changeTheme();
  }
}
