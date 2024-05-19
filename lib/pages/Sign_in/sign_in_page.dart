import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.

String? appleCredentialname;
String? appleCredentialemail;
String? name;
String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<UserCredential> signInWithGoogle() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    // Trigger the authentication flow

    final googleUser = await GoogleSignIn().signIn();
    showLoaderDialog(context);
    // Obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    String? token = credential.idToken.toString();

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithApple1() async {
    var appleProvider = AppleAuthProvider();
    await FirebaseAuth.instance.signInWithProvider(appleProvider);
  }

  Future<UserCredential> signInWithApple() async {
    final rawNonce = generateNonce();

    final nonce = sha256ofString(rawNonce);
    final sharedPreferences = await SharedPreferences.getInstance();
    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    showLoaderDialog(context);
    final oauthCredential = await OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
      rawNonce: rawNonce,
    );

    String? token = oauthCredential.idToken.toString();
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProv.isDarkTheme!
            ? const Color(0xFFEFEEFC)
            : const Color(0xFFEFEEFC),
        body: Stack(
          children: [
            buildBackground(),
            buildSignInWithEmail(context),
            buildSocialSignIn(context),
          ],
        ));
  }

  Positioned buildBackground() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(),
      ),
    );
  }

  Positioned buildSocialSignIn(BuildContext context) {
    // final myServices = Get.find();
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: 30,
      left: Const.margin,
      right: Const.margin,
      height: height * 0.37, //280
      child: Column(
        children: [
          Expanded(
            child: MyRaisedButton(
              onTap: () => Get.offAllNamed<dynamic>(
                Routes.signinwithemail,
              ), //Routes.signinwithemail
              label: AppLocalizations.of(context)!.continue_with_email,
              height: 40,
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final cred = await signInWithGoogle();
                print(cred);
                final user = cred.user;
                if (user != null) {
                  // mybox!.put('islogin', true);

                  mybox!.put('name', cred.user!.displayName!.split(' ')[0]);
                  await BooksApi().CheckLogin(
                    'google',
                    cred.user!.email,
                    cred.user!.uid,
                    cred.user!.displayName!.split(' ')[0],
                  );
                } else {
                  Navigator.pop(context);
                }
                ;
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(
                  color: Color(0xFFE0E2E3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(Const.google, height: 24),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: localeProv.localelang!.languageCode == 'en'
                            ? const EdgeInsets.only(top: 8)
                            : const EdgeInsets.only(),
                        child: Text(
                          AppLocalizations.of(context)!.continue_with_google,
                          style: theme.textTheme.labelMedium!.copyWith(
                              // color: Colors.red,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                final credapple = await signInWithApple();
                print("credapple ${credapple}");
                print(credapple);
                if (credapple.user != null) {
                  // ignore: avoid_dynamic_calls
                  final displayname = credapple.user!.displayName != null
                      ? credapple.user!.displayName!.split(' ')[0]
                      : "Apple";

                  final email = credapple.user!.email == null
                      ? credapple.user?.providerData
                          .firstWhereOrNull(
                              (userInfo) => userInfo.providerId == 'apple.com')
                          ?.email
                      : credapple.user!.email;
                  mybox!.put('name', displayname);
                  await BooksApi().CheckLogin(
                    'apple',
                    email,
                    credapple.user!.uid,
                    displayname,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                  color: Color(0xFFE0E2E3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(Const.appleblack, height: 24),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: localeProv.localelang!.languageCode == 'en'
                            ? const EdgeInsets.only(top: 8)
                            : const EdgeInsets.only(),
                        child: Text(
                          AppLocalizations.of(context)!.continue_with_apple,
                          style: theme.textTheme.labelMedium!.copyWith(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                late SharedPreferences sharedPreferences;
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setString("token", 'tokenGuest');
                mybox!.put('name', "Guest");
                Get.toNamed(Routes.home);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: const BorderSide(
                  color: Colors.transparent,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: localeProv.localelang!.languageCode == 'en'
                            ? const EdgeInsets.only(top: 10)
                            : const EdgeInsets.only(),
                        child: Text(
                          AppLocalizations.of(context)!.skib_sinup,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        width: 15,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.dont_have_an_account,
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color:
                          themeProv.isDarkTheme! ? Colors.black : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () => Get.toNamed<dynamic>(
                      Routes.mobilenumberpage,
                    ), //signup
                    child: Text(
                      AppLocalizations.of(context)!.register,
                      style: theme.textTheme.headlineSmall!
                          .copyWith(color: ColorLight.primary),
                    ),
                  ),
                ],
              ),
              PrivacyPolicy(),
            ],
          )
        ],
      ),
    );
  }

  Positioned buildSignInWithEmail(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final heigth = MediaQuery.of(context).size.height;
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      height: heigth * 0.6,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          // ignore: use_decorated_box
          Container(
            foregroundDecoration: BoxDecoration(
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0xFFEFEEFC),
                  spreadRadius: 280,
                  offset: Offset(100, 500), //(x,y)
                  blurRadius: 100,
                )
              ],
              color: const Color(0xFFEFEEFC).withOpacity(0.1),
            ),
            height: heigth * 0.22, //200
            width: double.infinity,
            child: Lottie.asset(
              Const.sign,
              width: double.infinity,
              // height: 200,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(
            height: heigth * 0.16,
          ),
          Text(
            AppLocalizations.of(context)!.lets_getstrat,
            style: theme.textTheme.headlineLarge!.copyWith(
              color: themeProv.isDarkTheme!
                  ? ColorDark.background
                  : ColorDark.background,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.sign_in_or_login,
            maxLines: 2,
            style: theme.textTheme.titleMedium!.copyWith(
              color: themeProv.isDarkTheme!
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF6B7280),
              fontSize: 13,
            ),
          ),
          //const Spacer(),
        ],
      ),
    );
  }

  Column PrivacyPolicy() {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.by_sign_in_i_accept,
              style: theme.textTheme.headlineSmall!.copyWith(
                color: themeProv.isDarkTheme! ? Colors.black : Colors.black,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.privacypolicy),
              child: Text(
                AppLocalizations.of(context)!.terms_of_Service,
                style: theme.textTheme.headlineSmall!
                    .copyWith(color: ColorLight.primary, fontSize: 8),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .and_community_guidelines_and_have_read,
              style: theme.textTheme.headlineSmall!.copyWith(
                color: themeProv.isDarkTheme! ? Colors.black : Colors.black,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.privacypolicy),
              child: Text(
                AppLocalizations.of(context)!.privacy_policy,
                style: theme.textTheme.headlineSmall!
                    .copyWith(color: ColorLight.primary, fontSize: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  showLoaderDialog(
    BuildContext context,
  ) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    AlertDialog alert = AlertDialog(
        insetPadding: EdgeInsets.only(
            bottom: height * 0.4,
            top: height * 0.20,
            left: width * 0.02,
            right: width * 0.02),
        content: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  AppLocalizations.of(context)!.waiting + "...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(height: 300, child: alert);
      },
    );
  }
}
