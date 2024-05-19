import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const String SECRET_KEY =
    "9eea8edfd0a3451994a6c6731c86577c8184fd30d95145b0883676dfb32a5de403ece58a06214e56942fd64c6ab34d31eb9e4b56e8af487d8313b7954141ca09b410d93a016c44b79585b01c87595f5e68e07863041043e1b025343656dbb40b66ce40dbf6c44fd3ab0fda88ab04e427ee9593188c1c4fb4b8be5c9ec2ce9281";
const String accessKey = "270de581d0d3393d98ef9ca57241f144";
const String profileId = "8A20E0DD-445B-46DB-98F9-9290EA04452F";

// Code to generate Signature
String sign(String data) {
  var encoding = utf8;
  var keyByte = encoding.encode(SECRET_KEY);
  var hmacsha256 = Hmac(sha256, keyByte);
  var messageBytes = encoding.encode(data);
  return base64.encode(hmacsha256.convert(messageBytes).bytes);
}

// Get Date
String getUtcDateTime() {
  DateTime time = DateTime.now().toUtc();
  return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(time);
}

// API Call
String paymentUrl = "https://testsecureacceptance.cybersource.com/pay";
String amount = "1";
String paymentDate = getUtcDateTime();
String transactionId = Uuid().v4();
String referenceId = Uuid().v4();
String data =
    "access_key=$accessKey,profile_id=$profileId,transaction_uuid=$transactionId,signed_field_names=access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,unsigned_field_names=,signed_date_time=$paymentDate,locale=en,transaction_type=authorization,reference_number=$referenceId,amount=$amount,currency=USD";
String signature = sign(data);

Future<void> PaymentGatewayflutter() async {
  try {
    final url = Uri.parse('https://testsecureacceptance.cybersource.com/pay');
    Map<String, String> requestBody = <String, String>{
      'access_key': accessKey,
      'profile_id': profileId,
      'transaction_uuid': transactionId,
      'signed_field_names':
          'access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency',
      'unsigned_field_names': '',
      'signed_date_time': paymentDate,
      'locale': 'en',
      'transaction_type': 'authorization',
      'reference_number': referenceId,
      'amount': amount,
      'currency': 'USD',
      'submit': 'Submit',
      'signature': signature,
    };
    var request = http.MultipartRequest('POST', url)
      ..fields.addAll(requestBody);
    var response = await request.send();
    String respStr = await response.stream.bytesToString();
    """
              <h3>Please Try Again <bird></bird></h3>
              """;
    if (response.statusCode == 200) {
      //  respStr = await response.stream.bytesToString();
      print(response);
    }
    // print(
    //   jsonDecode("flutter html $respStr"),
    // );
    print("signature   $respStr");
    print("paymentDate     $paymentDate");
    print("referenceId     $referenceId");
    print("data     $data");
    // await Get.toNamed<dynamic>(Routes.paymentflutter, arguments: respStr);
  } catch (error) {
    print(error);
  }
}
