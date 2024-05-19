import 'dart:io' show Platform;

import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../helpers/colors.dart';
import '../../providers/theme_provider.dart';

class SummariesLanguage extends StatefulWidget {
  const SummariesLanguage({super.key});

  @override
  State<SummariesLanguage> createState() => _SummariesLanguageState();
}

class _SummariesLanguageState extends State<SummariesLanguage> {
  final List<String> _selectValue = [];
  bool checkboxValue1 = true;
  bool checkboxValue2 = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final orientation = MediaQuery.of(context).orientation;
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
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
                  percent: 0.5,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: Colors.grey,
                  progressColor: ColorLight.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Text(
                AppLocalizations.of(context)!.summarie_lang,
                style: theme.textTheme.headlineLarge!.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ), //
            ),
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.only(top: 70.0, left: 10, right: 10),
                child: Text(
                  AppLocalizations.of(context)!.choose_witch_you_have_interest,
                  style: theme.textTheme.headlineLarge!
                      .copyWith(fontSize: 12, height: 1.3),
                  textAlign: TextAlign.start,
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: Column(children: <Widget>[
                CheckboxListTile(
                     side:  BorderSide(color: themeProv.isDarkTheme!
              ? Colors.white
              : ColorDark.background,),
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  value: checkboxValue1,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue1 = value!;
                      if (value != false) {
                        _selectValue.add('arabic');
                      } else {
                        _selectValue.remove('arabic');
                      }
                      mybox!.put("langsu", _selectValue);
                    });
                  },
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          Const.flagqatar,
                          width: 0,
                          height: 0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: localeProv.localelang!.languageCode == 'en'
                            ? const EdgeInsets.only(top: 8.0)
                            : EdgeInsets.all(0),
                        child: Text(
                          textDirection: TextDirection.rtl,
                          AppLocalizations.of(context)!.lang_ar,
                          style:  TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold,  color: themeProv.isDarkTheme!
              ? ColorLight.background
              : ColorDark.background,),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(height: 0),
                CheckboxListTile(
                  side:  BorderSide(color: themeProv.isDarkTheme!
              ? Colors.white
              : ColorDark.background,),
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  value: checkboxValue2,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue2 = value!;
                      if (value != false) {
                        _selectValue.add('english');
                      } else {
                        _selectValue.remove('english');
                      }
                      mybox!.put("langsu", _selectValue);
                      var val = mybox!.get('langsu');
                      print("langsu     $val");
                    });
                  },
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          Const.flagenglish,
                          width: 0,
                          height: 0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: localeProv.localelang!.languageCode == 'en'
                            ? const EdgeInsets.only(top: 8.0)
                            : EdgeInsets.all(0),
                        child: Text(
                          textDirection: TextDirection.rtl,
                          AppLocalizations.of(context)!.lang_en,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold,color: themeProv.isDarkTheme!
              ? ColorLight.background
              : ColorDark.background,),
                        ),
                      )
                    ],
                  ),
                ),
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
          label: AppLocalizations.of(context)!.setep2,
          onTap: () async {
            Get.toNamed(Routes.selectdarklight);
          },
        ),
      ),
    );
  }
}
