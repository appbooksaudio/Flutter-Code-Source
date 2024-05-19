
import 'package:ejazapp/bindings/dependency_injection.dart';
import 'package:ejazapp/bindings/initialbindings.dart';
import 'package:ejazapp/controllers/controllerlang.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/l10n/l10n.dart';
import 'package:ejazapp/providers/animation_test_play.dart';
import 'package:ejazapp/providers/audio_provider.dart';
import 'package:ejazapp/providers/download_provider.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/providers/timevideo.dart';
import 'package:ejazapp/route_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<dynamic> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
  DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerLang());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => BooksApi()),
        ChangeNotifierProvider(create: (context) => MyState()),
        ChangeNotifierProvider(create: (context) => FileDownloaderProvider()),
          ChangeNotifierProvider(create: (context) => Testplay()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, theme, locale, child) {
          return GetMaterialApp(
            title: 'Ejaz App',
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.rightToLeftWithFade,
            theme: controller.appTheme,
            darkTheme: controller.appThemedark, //controller.appThemedark
            themeMode:
                (theme.isDarkTheme == false) ? ThemeMode.light : ThemeMode.dark,
            locale: controller.language, // Get.devicelocale
            fallbackLocale: controller.language,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            localeResolutionCallback: (
              Locale? locale,
              Iterable<Locale> supportedLocales,
            ) {
              return locale;
            },
            initialRoute: Routes.splash,
            initialBinding: InitialBindings(),
            getPages: allPages,
          );
        },
      ),
    );
  }
}
