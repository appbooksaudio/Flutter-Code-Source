import 'package:ejazapp/core/class/statusrequest.dart';
import 'package:ejazapp/core/functions/handingdatacontroller.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/auth/login.dart';
import 'package:ejazapp/data/datasource/remote/firebaseapi/updatetoken.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class LoginController extends GetxController {
  login();
}

class LoginControllerImp extends LoginController {
  LoginData loginData = LoginData(Get.find());
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;

  MyServices myServices = Get.find();

  bool isshowpassword = true;

  StatusRequest statusRequest = StatusRequest.none;

  showPassword() {
    isshowpassword = isshowpassword == true ? false : true;
    update();
  }

  List data = [];

  @override
  login() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await loginData.postdata(email.text, password.text);
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['isSubscribed'] == true) {
          mybox!.put('PaymentStatus', 'success');
          myServices.prefs.setString('name', response['displayName'] as String);
          myServices.prefs.setString("authorized", response['token'] as String);
          myServices.prefs.setString("image", response['image'] as String);
          mybox!.put('name', response['displayName'] as String);
          await FirebaseMessaging.instance.getToken().then((value) {
            print(value);
            String? token = value;
            myServices.prefs.setString('token', token!);
            UpdateFirebaseToken(token);
          });
          Get.offNamed(Routes.home);
          return;
        }
        if (response['isSubscribed'] == false) {
          mybox!.put('PaymentStatus', 'pending');
          myServices.prefs.setString('name', response['displayName'] as String);
          myServices.prefs.setString("authorized", response['token'] as String);
          myServices.prefs.setString("image", response['image'] as String);
          mybox!.put('name', response['displayName'] as String);
          await FirebaseMessaging.instance.getToken().then((value) {
            print(value);
            String? token = value;
            myServices.prefs.setString('token', token!);
            UpdateFirebaseToken(token);
          });

          Get.offNamed(Routes.home);
          return;
        } else {
          ShowPopup(response);
        }
      } else {
        ShowPopup(response);
      }
      update();
    } else {}
  }

  @override
  goToSignUp() {
    //  Get.offNamed(AppRoute.signUp);
  }

  @override
  void onInit() {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   print(value);
    //   String? token = value;
    // });
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  goToForgetPassword() {
    // Get.toNamed(Routes.forgetPassword);
  }

  ShowPopup(var response) async {
    final error1 = "Wrong Password or Email!";
    await Get.dialog(
      barrierDismissible: false,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Alert",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${error1}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    //Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFFFFFFFF), backgroundColor: ColorLight.primary, minimumSize: const Size(20, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(Get.context as BuildContext);
                              statusRequest = StatusRequest.none;
                              update();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                'OK',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
