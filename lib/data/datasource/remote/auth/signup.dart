import 'dart:convert';

import 'package:ejazapp/connectapi/linkapi.dart';
import 'package:ejazapp/core/class/crud.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:get/get.dart';

class SignupData {
  Crud crud;
  MyServices myServices = Get.find();
  SignupData(this.crud);
  postdata(String FirebaseUID, String FirebaseToken, String username,
      String password, String email, String phone, String language) async {
    Map<String, String> data = {
      "FirebaseUID": "dgdfg",
      "FirebaseToken": "dfgdfg",
      "DisplayName": username,
      "Username": username,
      "Password": password,
      "Email": email,
      "Password": password,
      "PhoneNumber": myServices.prefs.getString('phone').toString(),
      "Language": myServices.prefs.getString('lang').toString(),
    };

    int contentlength = utf8.encode(json.encode(data)).length;
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength'
      //'Authorization': '<Your token>'
    };
    final msg = jsonEncode(data);
    var response = await crud.postData(AppLink.signup, msg, requestHeaders);
    return response.fold((l) => l, (r) => r);
  }
}
