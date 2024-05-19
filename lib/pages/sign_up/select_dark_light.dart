import 'dart:io' show Platform;

import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class SelectDarkLight extends StatefulWidget {
  const SelectDarkLight({super.key});

  @override
  State<SelectDarkLight> createState() => _SelectDarkLightState();
}

class _SelectDarkLightState extends State<SelectDarkLight> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            // color: themeProv.isDarkTheme!
            //     ? Color.fromARGB(255, 105, 104, 104)
            //     : const Color(0xFFF5F5F5),
            elevation: 0,
            height: Platform.isIOS ? 100 : 85,
            child: getStartedButton()),
        body: NestedScrollView(
          body: Stack(children: [
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(top: 120.0, left: 25, right: 25),
              child: RotatedBox(
                quarterTurns:
                    localeProv.localelang!.languageCode == 'ar' ? 2 : 0,
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 50,
                  lineHeight: 6.0,
                  percent: 0.75,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: Colors.grey,
                  progressColor: ColorLight.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Text(
                AppLocalizations.of(context)!.select_dark_light,
                style: theme.textTheme.headlineLarge!.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ), //
            ),
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.only(top: 70.0, left: 10, right: 10),
                child: Text(
                  AppLocalizations.of(context)!.choose_dark_mode,
                  style: theme.textTheme.headlineLarge!.copyWith(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.start,
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: Column(children: <Widget>[
                const SizedBox(height: 15),
                const Divider(height: 0),
                const SizedBox(height: 15),
                buildSettingApp(
                  context,
                  icon: Feather.moon,
                  title: AppLocalizations.of(context)!.turn_on,
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  trailing: Switch(
                    value: themeProv.isDarkTheme!,
                    activeColor: theme.primaryColor,
                     inactiveTrackColor: theme.primaryColor,
                    onChanged: (val) {
                      themeProv.changeTheme();
                    },
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(height: 0),
              ]),
            ),
          ]),
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

  SizedBox getStartedButton() {
    return SizedBox(
      height: 45,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 5, bottom: 10, left: 30.0, right: 30),
        child: MyRaisedButton(
          height: 100,
          width: 50,
          label: AppLocalizations.of(context)!.setep3,
          onTap: () async {
            Get.toNamed(Routes.uploadedavatar);
          },
        ),
      ),
    );
  }

  InkWell buildSettingApp(
    BuildContext context, {
    required String title,
    TextStyle? style,
    IconData? icon,
    Widget? trailing,
    void Function()? onTap,
  }) {
    final themeProv = Provider.of<ThemeProvider>(context);
     final localeProv = Provider.of<LocaleProvider>(context);
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Const.margin),
        child: Row(
          children: [
            Icon(
              icon,
              color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 15),
            Expanded(child: Padding(
              padding:localeProv.localelang!.languageCode == 'ar'? const EdgeInsets.only(top:0.0):const EdgeInsets.only(top:12.0),
              child: Text(title, style: style),
            )),
            trailing!,
          ],
        ),
      ),
    );
  }
}
