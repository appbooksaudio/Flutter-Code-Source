import 'package:ejazapp/core/class/statusrequest.dart';
import 'package:ejazapp/core/functions/handingdatacontroller.dart';
import 'package:ejazapp/data/datasource/remote/auth/updatepassword.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class UpdatePasswordController extends GetxController {
  void get statusRequest => null;
}

class UpdatePasswordControllerImp extends UpdatePasswordController {
  GlobalKey<FormState> formstatekey = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController currentpassword;
  late TextEditingController newpassword;
  late TextEditingController confirmpassword;

  @override
  StatusRequest statusRequest = StatusRequest.none;

  UpdatepasswordData updatepassword = UpdatepasswordData(Get.find());

  List data = [];

  void updatepass() async {
    if (formstatekey.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response =
          await updatepassword.postdata(currentpassword.text, newpassword.text);
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['isSubscribed'] == false) {
          print(response);
          Get.toNamed<dynamic>(Routes.signinwithemail,
              arguments: ""); //signinwithemail
          Get.snackbar(
            'Alert',
            'Password updated successful',
            colorText: Colors.white,
            backgroundColor: Colors.green,
            icon: const Icon(Icons.login),
          );
        } else {
          Get.snackbar(
            'Alert',
            'Current Password incorrect',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.login),
          );
          statusRequest = StatusRequest.failure;
        }
      } else {
        final errors = response;
        await Get.dialog(
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
                    child: Material(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Alert",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "$errors",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          //Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Color.fromARGB(255, 232, 45, 45), minimumSize: const Size(0, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.offAllNamed(Routes.signin);
                                  },
                                  child: const Text(
                                    'NO',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xFFFFFFFF), backgroundColor: Color.fromARGB(255, 10, 113, 10), minimumSize: const Size(0, 45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.offAllNamed<dynamic>(Routes.signup,
                                        arguments: "");
                                  },
                                  child: const Text(
                                    'Try Agin',
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
              ),
            ],
          ),
        );
      }
      update();
    } else {}
  }

  @override
  void onInit() {
    confirmpassword = TextEditingController();
    email = TextEditingController();
    newpassword = TextEditingController();
    currentpassword = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    confirmpassword.dispose();
    newpassword.dispose();
    currentpassword.dispose();
    super.dispose();
  }
}
