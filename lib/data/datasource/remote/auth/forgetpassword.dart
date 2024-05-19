import 'dart:convert';

import 'package:ejazapp/connectapi/linkapi.dart';
import 'package:ejazapp/core/class/crud.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:get/get.dart';

class ForgetpasswordData {
  Crud crud;
  MyServices myServices = Get.find();
  ForgetpasswordData(this.crud);
  postdata(String password, String phone) async {
    Map<String, String> data = {
      "newPassword": password,
      "phoneNumber": myServices.prefs.getString('phone').toString(),
    };

    int contentlength = utf8.encode(json.encode(data)).length;
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength'
      //'Authorization': '<Your token>'
    };
    final msg = jsonEncode(data);
    var response =
        await crud.postData(AppLink.forgetpassword, msg, requestHeaders);
    return response.fold((l) => l, (r) => r);
  }
}
