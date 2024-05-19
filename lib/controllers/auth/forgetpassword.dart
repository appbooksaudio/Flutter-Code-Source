import 'package:ejazapp/core/class/statusrequest.dart';
import 'package:ejazapp/core/functions/handingdatacontroller.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/auth/forgetpassword.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ForgetpasswordController extends GetxController {
  get statusRequest => null;
}

class ForgetpasswordControllerImp extends ForgetpasswordController {
  GlobalKey<FormState> formstatefor = GlobalKey<FormState>();

  late TextEditingController phone;
  late TextEditingController password;
  late TextEditingController confirmpassword;

  @override
  StatusRequest statusRequest = StatusRequest.none;

  ForgetpasswordData forgetpData = ForgetpasswordData(Get.find());
  MyServices myServices = Get.find();
  List data = [];

  // ignore: always_declare_return_types, inference_failure_on_function_return_type
  forgetpassword() async {
    if (formstatefor.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await forgetpData.postdata(password.text, phone.text);
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        await Get.snackbar('Alert', "Password changed ",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.greenAccent,
            icon: const Icon(Icons.login));
        await Get.toNamed(Routes.signinwithemail);
      } else {
        RegExp regExp = new RegExp(r'^[0-9a-fA-F]+');
        final errors = response['errors'].toString();
        final error1 =
            errors.replaceAll(RegExp('[^A-Za-z0-9]'), ' ').toString();

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
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        //Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(""),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color(0xFFFFFFFF), backgroundColor: ColorLight.primary, minimumSize: const Size(20, 45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(Get.context as BuildContext);
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
        statusRequest = StatusRequest.failure;
      }
    } else {
      update();
    }
  }

  @override
  void onInit() {
    confirmpassword = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }
}
