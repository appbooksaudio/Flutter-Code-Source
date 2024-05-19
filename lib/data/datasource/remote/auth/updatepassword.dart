import 'dart:convert';

import 'package:ejazapp/connectapi/linkapi.dart';
import 'package:ejazapp/core/class/crud.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatepasswordData {
  Crud crud;
  MyServices myServices = Get.find();
  UpdatepasswordData(this.crud);
  late SharedPreferences sharedPreferences;
  postdata(String currentpassword, String newpassword) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    Map<String, String> data = {
      "CurrentPassword": currentpassword,
      "NewPassword": newpassword,
    };

    int contentlength = utf8.encode(json.encode(data)).length;
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    var response =
        await crud.postData(AppLink.updatepassword, msg, requestHeaders);
    return response.fold((l) => l, (r) => r);
  }
}
