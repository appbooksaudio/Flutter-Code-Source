import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejazapp/core/class/statusrequest.dart';
import 'package:ejazapp/core/functions/handingdatacontroller.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/auth/signup.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class SignUpController extends GetxController {
  get statusRequest => null;

  signUp();
  goToSignIn();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late String firebaseToken = '';
  late String firebaseUID = '';
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController password;
  late TextEditingController confirmpassword;
  late String language;

  @override
  StatusRequest statusRequest = StatusRequest.none;

  SignupData signupData = SignupData(Get.find());
  MyServices myServices = Get.find();
  List data = [];

  @override
  signUp() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await signupData.postdata(
        firebaseUID,
        firebaseToken,
        username.text,
        password.text,
        email.text,
        phone.text,
        language,
      );
      statusRequest = handlingData(response);
      if (StatusRequest.success == statusRequest) {
        if (response['isSubscribed'] == true) {
          mybox!.put('PaymentStatus', 'success');
          myServices.prefs.setString("authorized", response['token'] as String);
          //print(response);
          await BooksApi().getCategory();
            await    CreateUser(email.text,password.text,username.text);
          await Get.toNamed<dynamic>(Routes.selectcategory,
              arguments: ""); //signinwithemail
        
        } else if (response['isSubscribed'] == false) {
          mybox!.put('PaymentStatus', 'pending');
          myServices.prefs.setString("authorized", response['token'] as String);
          //print(response);
          await BooksApi().getCategory();
          await   CreateUser(email.text,password.text,username.text);
          await Get.toNamed<dynamic>(Routes.selectcategory,
              arguments: ""); //signinwithemail
         
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
                            "${error1.split('  ')[1]}",
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
                                    statusRequest = StatusRequest.none;
                                    update();
                                    // Get.toNamed(Routes.signup);
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
    } else {}
  }

  @override
  goToSignIn() {
    Get.offNamed(Routes.signin);
  }

  @override
  void onInit() {
    firebaseUID = "";
    firebaseToken = "";
    language = "";
    confirmpassword = TextEditingController();
    username = TextEditingController();
    phone = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

 CreateUser(String email,String password,String username) async{
   
  UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
User user = result.user!;
await FirebaseFirestore.instance.collection('users')
      .doc(user.uid).set({ 'firstName': username,'email':email});
      print("user created by email and password");

       String displayname =mybox!.get('name');
    final FirebaseAuth _auth = await FirebaseAuth.instance;
    if( _auth.currentUser!.displayName == null)
    { 
      await _auth.currentUser!.updateDisplayName(displayname);
    
    }
}



}
