import 'package:ejazapp/controllers/otp_controller.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OTPView extends GetView<HomeController> {
  const OTPView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    String? phone = controller.MobPhone.toString();
    MyServices myServices = Get.find();
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      body: controller.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      AppLocalizations.of(context)!.verification_code,
                      style: theme.textTheme.headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.we_have_sent_the_code_verification_to_your_phone_number} $phone',
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Obx(
                      () => PinFieldAutoFill(
                        textInputAction: TextInputAction.done,
                        controller: controller.otpEditingController,
                        cursor: Cursor(
                          width: 2,
                          height: 30,
                          color: Colors.blue,
                          radius: Radius.circular(1),
                          enabled: true,
                        ),
                        decoration: UnderlineDecoration(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: themeProv.isDarkTheme!
                                ? Colors.white
                                : Colors.black,
                          ),
                          colorBuilder: FixedColorBuilder(ColorLight.primary),
                        ),
                        currentCode: controller.messageOtpCode.value,
                        onCodeSubmitted: (code) {},
                        onCodeChanged: (code) async {
                          controller.messageOtpCode.value = code!;
                          controller.countdownController.pause();
                          if (code.length == 6) {
                            controller.isLoaded == true;
                            // To perform some operation
                            print(Get.arguments['value']);
                            try {
                              print(controller.verificationCode);
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId:
                                              controller.verificationCode!,
                                          smsCode: code))
                                  .then((value) async {
                                if (value.user != null) {
                                  print('verificationdone');
                                  if (Get.arguments['value'] != 'reset') {
                                    await myServices.prefs.setString('phone',
                                        controller.MobPhone.toString());
                                    controller.MobPhone = "";
                                    controller.isLoaded == false;
                                    Get.toNamed<dynamic>(Routes.signup);
                                  } else {
                                    await myServices.prefs.setString('phone',
                                        controller.MobPhone.toString());
                                    controller.MobPhone = "";
                                    await Get.toNamed<dynamic>(
                                        Routes.resetpassword);
                                    controller.isLoaded == false;
                                  }
                                } else {
                                  controller.isLoaded == false;
                                  await Get.defaultDialog(
                                      barrierDismissible: true,
                                      title: "Alert",
                                      middleText: "Plase,Check The Code ",
                                      backgroundColor: Colors.white,
                                      titleStyle: const TextStyle(
                                          color: Colors.blue, fontSize: 25),
                                      middleTextStyle: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                      radius: 30);
                                }
                              });
                            } catch (e) {
                              controller.isLoaded == false;
                              await Get.defaultDialog(
                                  barrierDismissible: true,
                                  title: "Alert",
                                  middleText: e.toString().split(']')[1],
                                  backgroundColor: Colors.white,
                                  titleStyle: const TextStyle(
                                      color: Colors.blue, fontSize: 25),
                                  middleTextStyle: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                  radius: 30);
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Countdown(
                      controller: controller.countdownController,
                      seconds: 60,
                      interval: const Duration(milliseconds: 1000),
                      build: (context, currentRemainingTime) {
                        if (currentRemainingTime == 0.0) {
                          return GestureDetector(
                            onTap: () {
                              // write logic here to resend OTP
                              Get.toNamed<dynamic>(Routes.mobilenumberpage);
                              phone = "";
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 14, bottom: 14),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  border:
                                      Border.all(color: Colors.blue, width: 1),
                                  color: Colors.blue),
                              width: context.width,
                              child: Text(
                                AppLocalizations.of(context)!.resend_a_new_code,
                                style: theme.textTheme.headlineLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorLight.background,
                                    fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 14, bottom: 14),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              // border:
                              //     Border.all(color: Colors.blue, width: 1),
                            ),
                            width: context.width,
                            child: Text(
                                "${AppLocalizations.of(context)!.exprire_code} ${currentRemainingTime.toString().length == 4 ? " ${currentRemainingTime.toString().substring(0, 2)}" : " ${currentRemainingTime.toString().substring(0, 1)}"} s",
                                style: const TextStyle(fontSize: 16)),
                          );
                        }
                      },
                    ),
                  ])),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
              backgroundColor: theme.colorScheme.background,
              foregroundColor:
                  themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
              actions: [
                IconButton(
                  color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () => Get.toNamed<dynamic>(Routes.signin),
                ),
              ],
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: true),
        ];
      },
    ));
  }
}
