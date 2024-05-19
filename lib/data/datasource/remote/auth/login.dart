import 'dart:convert';

import 'package:ejazapp/connectapi/linkapi.dart';
import 'package:ejazapp/core/class/crud.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);

  postdata(String email, String password) async {
    Map<String, String> data = {
      "Password": password,
      "Email": email,
    };

    var contentlength = utf8.encode(json.encode(data)).length;
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      //'Authorization': '<Your token>'
    };
    final msg = jsonEncode(data);

    final response = await crud.postData(AppLink.login, msg, requestHeaders);
    return response.fold((l) => l, (r) => r);
  }
}
