import 'dart:io';

import 'package:ejazapp/controllers/controllerlang.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/l10n/l10n.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  Locale? _selectedLocale = L10n.all.first;

  @override
  void initState() {
    super.initState();
    switch (Platform.localeName) {
      case 'ar_SA':
        _selectedLocale = L10n.all.first;
        break;
      default:
        _selectedLocale = L10n.all[1];
    }
  }

  String language(String val) {
    switch (val) {
      case 'ar':
        return '${AppLocalizations.of(context)!.lang_ar}';
      default:
        return '${AppLocalizations.of(context)!.lang_en}';
    }
  }

  Widget Flag(String val) {
    switch (val) {
      case 'ar':
        return Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              Const.flagqatar,
              width: 0,
              height: 0,
              fit: BoxFit.cover,
            ),
          ),
        );
      default:
        return Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              Const.flagenglish,
              width: 0,
              height: 0,
              fit: BoxFit.cover,
            ),
          ),
        );
        ;
    }
  }

  @override
  Widget build(BuildContext context) {
    ControllerLang controller = Get.find();
    final theme = Theme.of(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Const.margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              AppLocalizations.of(context)!.ejazapp,
              style: theme.textTheme.headlineLarge!.copyWith(fontSize: 32),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.language,
              style: theme.textTheme.headlineMedium!
                  .copyWith(fontSize: 25, height: 1.2),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.descrition_navigation_language,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 40),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: L10n.all.map((locale) {
                    return RadioListTile(
                       fillColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return theme.primaryColor;
                          }
                          return Colors.white;
                        },
                      ),
                      value: locale,
                      contentPadding: EdgeInsets.zero,
                      activeColor: theme.primaryColor,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              language(locale.languageCode),
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Flag(locale.languageCode),
                          ],
                        ),
                      ),
                      groupValue: _selectedLocale,
                      onChanged: (dynamic value) {
                        setState(() {
                          _selectedLocale = locale;
                          localeProv.setLocale(locale);
                        });
                        controller.ChangeLang(locale.languageCode);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
                child: MyRaisedButton(
              label: AppLocalizations.of(context)!.confirm,
              onTap: () {
                Get.offAllNamed<dynamic>(Routes.onboarding);
              },
            ))
          ],
        ),
      ),
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
              automaticallyImplyLeading: false),
        ];
      },
    ));
  }
}
