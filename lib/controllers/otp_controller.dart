import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';

class HomeController extends GetxController {
  String? verificationCode;
  String? MobPhone = Get.arguments['phone'].toString();
  final TextEditingController _pinPutController = TextEditingController();
  String otpCode = "";
  String otp = "";
  bool isLoaded = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  CountdownController countdownController = CountdownController();
  TextEditingController otpEditingController = TextEditingController();
  var messageOtpCode = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    _verifyPhone();
    await SmsAutoFill().getAppSignature;
    // Listen for SMS OTP
    await SmsAutoFill().listenForCode();
  }

  @override
  void onReady() {
    super.onReady();
    countdownController.start();
  }

  @override
  void onClose() {
    super.onClose();
    // otpEditingController.dispose();
    SmsAutoFill().unregisterListener();
  }

  _verifyPhone() async {
    print(Get.arguments['phone']);
    String phone = Get.arguments['phone'].toString();
    int num = int.parse(phone);

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {}
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          String? result = e.message;
          // ignore: inference_failure_on_function_invocation
          Get.defaultDialog(
              barrierDismissible: true,
              title: "Alert",
              middleText: result.toString(),
              backgroundColor: Colors.white,
              titleStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
              middleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
              radius: 30);
        },
        codeSent: (String? verficationID, int? resendToken) {
          //  setState(() {
          verificationCode = verficationID;
          //  });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          //  setState(() {
          verificationCode = verificationID;
          //  });
        },
        timeout: Duration(seconds: 120));
  }
}
