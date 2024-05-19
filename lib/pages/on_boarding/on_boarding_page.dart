import 'package:device_info_plus/device_info_plus.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/pages/on_boarding/local_data/onboarding_model.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  SharedPreferences? sharedPreferences;
  int _currentIndexPage = 0;
  PageController? _pageController;
  bool? isIpadR = false;

  List<OnBoardingModel> onBoardingList(BuildContext context) => [
        OnBoardingModel(
          title: AppLocalizations.of(context)!.follow_your_favorites,
          subtitle: AppLocalizations.of(context)!.find_and_attend,
          image: Const.onBoardingImage1, //Const.logoblue,
        ),
        OnBoardingModel(
          title: AppLocalizations.of(context)!.discover_great,
          subtitle: AppLocalizations.of(context)!.find_and_attend_one,
          image: Const.onBoardingImage2,
        ),
        OnBoardingModel(
          title: AppLocalizations.of(context)!.follow_your_favorites_two,
          subtitle: AppLocalizations.of(context)!.find_and_attend_two,
          image: Const.onBoardingImage3,
        ),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndexPage);
    isIpad();
  }

  Future<bool> isIpad() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //*************** Ios device check  *************/
    IosDeviceInfo info = await deviceInfo.iosInfo;
    if (info.name != null) if (info.name!.toLowerCase().contains("ipad")) {
      //ipad
      setState(() {
        isIpadR = true;
      });
      print("isIpadR  $isIpadR");
      return true;
    }
    setState(() {
      isIpadR = false;
    });
    //*************** android device check  *************/
    IosDeviceInfo infoAndroid = await deviceInfo.iosInfo;
    if (infoAndroid.name != null) if (infoAndroid.name!
        .toLowerCase()
        .contains("tablet")) {
      //ipad
      setState(() {
        isIpadR = true;
      });
      print("isIpadR  $isIpadR");
      return true;
    }
    setState(() {
      isIpadR = false;
    });

    print("isIpadR  $isIpadR");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // skipButton(context),
          mainSection(context),
          Positioned(
            bottom: height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: DotsIndicator(
                dotsCount: onBoardingList(context).length,
                position: _currentIndexPage,
                decorator: DotsDecorator(
                  activeColor: Theme.of(context).primaryColor,
                  activeSize: const Size(18, 9),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          getStartedButton(),
        ],
      ),
    );
  }

  Positioned skipButton(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      top: 65,
      right: Const.margin,
      child: InkWell(
        onTap: () => checkLog(),
        child: Text(
          '${AppLocalizations.of(context)!.skip} >>',
          style:
              theme.textTheme.titleLarge!.copyWith(color: theme.primaryColor),
        ),
      ),
    );
  }

  Positioned mainSection(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 100,
      child: PageView.builder(
        controller: _pageController,
        itemCount: onBoardingList(context).length,
        onPageChanged: (value) {
          setState(() {
            _currentIndexPage = value;
          });
        },
        itemBuilder: (context, index) {
          final item = onBoardingList(context)[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: Container(
                //width: width,
                child: Lottie.asset(
                  item.image!,
                  width: double.infinity,
                  height: height *
                      0.56, //isIpadR == false ? height * 0.6 : height * 0.2,
                  fit: isIpadR == false ? BoxFit.fill : BoxFit.contain,
                ),
              )),
              SizedBox(height: MediaQuery.of(context).size.width * 0.1),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.title!,
                    style: theme.textTheme.headlineLarge!.copyWith(
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      item.subtitle!,
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),

              //Image.asset(item.image!)),
            ],
          );
        },
      ),
    );
  }

  Positioned getStartedButton() {
    return Positioned(
      bottom: 50,
      left: Const.margin,
      right: Const.margin,
      height: 55,
      child: MyRaisedButton(
        label: AppLocalizations.of(context)!.get_started,
        onTap: () async {
          if (_currentIndexPage == 2) {
            sharedPreferences = await SharedPreferences.getInstance();
            if (sharedPreferences?.getString("token") == null ||
                sharedPreferences?.getString("token") == "") {
              Get.offAllNamed<dynamic>(Routes.signin);
            } else {
              Get.offAllNamed<dynamic>(Routes.home);
            }
          } else {
            _pageController!.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
      ),
    );
  }

  void checkLog() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences?.getString("token") == null ||
        sharedPreferences?.getString("token") == "") {
      Get.offAllNamed<dynamic>(Routes.signin);
    } else {
      Get.offAllNamed<dynamic>(Routes.home);
    }
  }
}
