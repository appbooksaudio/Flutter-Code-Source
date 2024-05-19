import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ejazapp/core/class/statusrequest.dart';
import 'package:http/http.dart' as http;

class Crud {
  Future<Either<StatusRequest, Map>> postData(
      String linkurl, String data, Map<String, String>? header) async {
    bool check = true; // await checkInternet();
    if (check) {
      final response =
          await http.post(Uri.parse(linkurl), body: data, headers: header);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        final responsebody = json.decode(response.body) as Map<String, dynamic>;
        print('crud =========$responsebody');
        Map<String, dynamic> map =
            json.decode(response.body) as Map<String, dynamic>;

        return Right(responsebody);
      } else {
        // ignore: inference_failure_on_function_invocation
        // await  Get.defaultDialog(title: 'ُAlert',
        //   middleText: '$errors',
        //   );
        final responsebody = json.decode(response.body) as Map<String, dynamic>;
        return Right(responsebody);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }
}
