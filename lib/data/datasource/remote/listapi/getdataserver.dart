// ignore_for_file: strict_raw_type

import 'dart:async';
import 'dart:convert';

import 'package:ejazapp/connectapi/linkapi.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/firebaseapi/updatetoken.dart';
import 'package:ejazapp/data/models/authors.dart';
import 'package:ejazapp/data/models/banner.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/data/models/category.dart';
import 'package:ejazapp/data/models/collections.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BooksApi extends ChangeNotifier {
  List books = [];
  List collection = [];
  bool isLooding = true;


//******************* Function getbooks ******************//

  void getBooks() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    Map<String, String> data = {
      'pageNumber': '1',
      'pageSize': '1000',
      'all': 'true'
    };
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      //'Content-Length': '$contentlength',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.getbook,
    );
    final response = await http.get(
      url,
      headers: requestHeaders,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      mockBookList = [];
      books = json.decode(response.body) as List;
      var i = 0;
      books.forEach((element) {
        Map? obj = element as Map;
        List categories = obj['categories'] as List;
        List authors = obj['authors'] as List;
        List tags = obj['tags'] as List;
        List genres = obj['genres'] as List;
        List publishers = obj['publishers'] as List;
        List thematicAreas = obj['thematicAreas'] as List;
        List media = obj['media'] as List;
        String image;
        if (media.length > 0) {
          image = media[0]['md_URL'] != null  //md_ID
              ? media[0]['md_URL'] as String   //md_ID
              : "5337aa5b-949b-4dd2-8563-08db749b866d";
        } else {
          image = '5337aa5b-949b-4dd2-8563-08db749b866d';
        }

        //**** get audio    *////
        String audioEn = obj['md_AudioEn_ID'] != null
            ? obj['md_AudioEn_ID'] as String
            : 'd580315c-a7cd-450f-b261-08db8eaaaad1';

        String audioAr = obj['md_AudioAr_ID'] != null
            ? obj['md_AudioAr_ID'] as String
            : "316e6cb7-4863-4fd2-8aaa-08db9c90bda8";

        mockBookList.add(
          Book(
            bk_ID: obj['bk_ID'] as String, //as String
            bk_Code: obj['bk_Code'] as String,
            bk_Name: obj['bk_Name'] == 'N/A'
                ? obj['bk_Name_Ar'] as String
                : obj['bk_Name'] != null
                    ? obj['bk_Name'] as String
                    : "",
            bk_Name_Ar:
                obj['bk_Name_Ar'] != null ? obj['bk_Name_Ar'] as String : "",
            bk_Introduction: obj['bk_Introduction'] == 'N/A'
                ? obj['bk_Introduction_Ar'] as String
                : obj['bk_Introduction'] != null
                    ? obj['bk_Introduction'] as String
                    : "",
            bk_Introduction_Ar: obj['bk_Introduction_Ar'] != null
                ? obj['bk_Introduction_Ar'] as String
                : "",
            bk_Summary: obj['bk_Summary'] == 'N/A'
                ? obj['bk_Summary_Ar'] as String
                : obj['bk_Summary'] != null
                    ? obj['bk_Summary'] as String
                    : "",
            bk_Summary_Ar: obj['bk_Summary_Ar'] != null
                ? obj['bk_Summary_Ar'] as String
                : "",
            bk_Characters: obj['bk_Characters'] == 'N/A'
                ? obj['bk_Characters_Ar'] as String
                : obj['bk_Characters'] != null
                    ? obj['bk_Characters'] as String
                    : "",
            bk_Characters_Ar: obj['bk_Characters_Ar'] != null
                ? obj['bk_Characters_Ar'] as String
                : "",
            bk_Desc: obj['bk_Desc'] == 'N/A'
                ? obj['bk_Desc_Ar'] as String
                : obj['bk_Desc'] != null
                    ? obj['bk_Desc'] as String
                    : "",
            bk_Desc_Ar:
                obj['bk_Desc_Ar'] != null ? obj['bk_Desc_Ar'] as String : "",
            bk_Language: obj['bk_Language'] == 'N/A'
                ? obj['bk_Language_ Ar'] as String
                : obj['bk_Language'] != null
                    ? obj['bk_Language'] as String
                    : "",
            bk_Language_Ar: obj['bk_Language_Ar'] != null
                ? obj['bk_Language_Ar'] as String
                : "",
            bk_Active: obj['bk_Active'] as bool,
            bk_CreatedOn: obj['bk_CreatedOn'] as String,
            bk_trial: obj['bk_Trial'] as bool,
            // bk_Modifier: obj['bk_Modifier'] as String,
            audioEn:
                'https://ejaz.applab.qa/api/ejaz/v1/Medium/getAudio/$audioEn',
            audioAr:
                'https://ejaz.applab.qa/api/ejaz/v1/Medium/getAudio/$audioAr',
            imagePath:image,
                //'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/$image', //obj['media'] as String,
            categories: categories,
            authors: authors,
            tags: tags,
            genres: genres,
            publishers: publishers,
            thematicAreas: thematicAreas,
          ),
        );
        i + 1;
        this.isLooding = false;
        notifyListeners();
      });
    } else {
      this.isLooding = true;
      books = mockBookList;
      notifyListeners();

      String ApiName = "GetBooks";
      // await SendEmailException(response.body, ApiName);
      //throw Exception();
    }
    // return books
    //     .map((json) => Book.fromJson(json as Map<String, dynamic>))
    //     .toList();
  }

//******************* Function getCategory ******************//

  getCategory() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }
    String data = "";
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      // 'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.category,
    );
    final response = await http.get(
      url,
      headers: requestHeaders,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      CategoryList = [];
      books = json.decode(response.body) as List;
      var i = 0;
      books.forEach((element) {
        Map? obj = element as Map;
        String image = obj['md_ID'] != null ? obj['md_ID'] as String : "";
        CategoryList.add(CategoryL(
            ct_ID: obj['ct_ID'] as String,
            ct_Name: obj['ct_Name'] as String,
            ct_Title: obj['ct_Title'] as String,
            ct_Name_Ar: obj['ct_Name_Ar'] as String,
            ct_Title_Ar: obj['ct_Title_Ar'] as String,
            id: 0,
            imagePath:
                'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/$image',
            md_ID: '',
            title: ''));
        i + 1;
      });
    } else {
      String ApiName = "GetCategory";
      //  await SendEmailException(response.body, ApiName);
      //throw Exception();
    }
  }

//************* getAauthors   ************************* */
  void getAuthors() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }
    String data = "";
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      // 'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.authors,
    );
    final response = await http.get(
      url,
      headers: requestHeaders,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      mockAuthors = [];
      books = json.decode(response.body) as List;
      var i = 0;
      books.forEach((element) {
        Map? obj = element as Map;
        String image = obj['md_ID'] as String;
        mockAuthors.add(Authors(
          at_ID: obj['at_ID'] as String,
          at_Name: obj['at_Name'] as String,
          at_Name_Ar: obj['at_Name_Ar'] as String,
          imagePath:
              'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/$image',
          at_Active: obj['at_Active'] as bool,
          at_Desc: obj['at_Desc'] as String,
          at_Desc_Ar: obj['at_Desc_Ar'] as String,
          isDarkMode: true,
        ));
        i + 1;
      });
    } else {
      String ApiName = "getAuthors";
      //  await SendEmailException(response.body, ApiName);
      // throw Exception();
    }
  }

//******************* Function SignupGoogleApple  ******************//

  SignupGoogleApple(
      String username, String? email, String? FirebaseUID, String type) async {
     
    var uid = Uuid().v4();
    // ignore: omit_local_variable_types
    Map<String, String> data = {
      "FirebaseUID": FirebaseUID!,
      "FirebaseToken": "dfgdfg",
       "DisplayName": type == 'google' ? username : email as String,
       "Username": type == 'google'
          ? username + "@" + uid.split('-')[0]
          : email as String,
      "Password": 'GoogleApple@12345',
      "Email": email!,
      "PhoneNumber": FirebaseUID,
      "Language": "All",
    };
    // ignore: prefer_final_locals
    int contentlength = utf8.encode(json.encode(data)).length;

    // ignore: omit_local_variable_types
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      //'Host': '0',
      // 'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.signup,
    );
    final response = await http.post(url,
        headers: requestHeaders, body: msg); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final responsebody = json.decode(response.body) as Map<String, dynamic>;
      await mybox!.put('islogin', true);
      if (responsebody['isSubscribed'] == true) {
        mybox!.put('PaymentStatus', 'success');
        await sharedPreferences.setString(
            'name', responsebody['displayName'] as String);
        await sharedPreferences.setString(
            "authorized", responsebody['token'] as String);
        await sharedPreferences.setString(
            "image", responsebody['image'] as String);
        /********************Start Firebase generate token *********************/
        await FirebaseMessaging.instance.getToken().then((value) {
          print(value);
          String? token = value;
          sharedPreferences.setString('token', token!);
          UpdateFirebaseToken(token);
        });

        /********************End Firebase generate token *********************/
     
        await Get.offAllNamed(Routes.home, arguments: "");
      } else if (responsebody['isSubscribed'] == false) {
        mybox!.put('PaymentStatus', 'pending');

        await sharedPreferences.setString(
            'name', responsebody['displayName'] as String);
        await sharedPreferences.setString(
            "authorized", responsebody['token'] as String);
        await sharedPreferences.setString(
            "image", responsebody['image'] as String);
        /********************Start Firebase generate token *********************/
        await FirebaseMessaging.instance.getToken().then((value) {
          print(value);
          String? token = value;
          sharedPreferences.setString('token', token!);
          UpdateFirebaseToken(token);
        });

        /********************End Firebase generate token *********************/
       
        await Get.offAllNamed(Routes.home, arguments: "");
      }
    } else {
     
      print("response  ${response.body}");
      String ApiName = "Signup With Google and Apple";
      // await SendEmailException(response.body, ApiName);
      Get.rawSnackbar(
          messageText: const Text('User Name or Email Exist!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: ColorLight.primary,
          icon: const Icon(
            Icons.sentiment_very_dissatisfied,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
      var timer = Timer(Duration(seconds: 10), () => CloseRawSnakerbar());
    }
  }

  //******************* Function Get Subscription  ******************//

  void GetSubscription() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    Map<String, String> data = {};
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      // 'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.getsubscritipn,
    );
    final response = await http.get(
      url,
      headers: requestHeaders,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      final responsebody = json.decode(response.body) as List<dynamic>;
      await mybox!.put('subscriptionplan', responsebody);
      print("subscription result $responsebody");
    } else {
      String ApiName = "GetSubscription";
      // await SendEmailException(response.body, ApiName);
    }
  }
  //******************* Function Get EjazCollection  ******************//

  void GetEjazCollection() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    Map<String, String> data = {};
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      // 'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.getejazcollection,
    );
    final response = await http.get(
      url,
      headers: requestHeaders,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      final responsebody = json.decode(response.body) as List<dynamic>;
      await mybox!.put('getejazcollection', responsebody);
      collectionList = [];
      collection = json.decode(response.body) as List;
      var i = 0;
      collection.forEach((element) {
        Map? obj = element as Map;
        String image = obj['md_ID'] as String;
        collectionList.add(Collections(
          bc_ID: obj['bc_ID'] as String,
          bc_Title: obj['bc_Title'] as String,
          bc_Title_Ar: obj['bc_Title_Ar'] as String,
          imagePath:
              'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/$image',
          bc_Active: obj['bc_Active'] as bool,
          bc_Desc: obj['bc_Desc'] as String,
          bc_Summaries: obj['bc_Summaries'] as int,
        ));
        i + 1;
      });
    } else {
      String ApiName = "GetEjazCollection";
      //  await SendEmailException(response.body, ApiName);
    }
  }

  //******************* Function Get EjazCollectionById  ******************//
  void GetEjazCollectionById(id) async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    Map<String, String> data = {};
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      // 'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      'https://ejaz.applab.qa/api/ejaz/v1/BookCollection/getBookCollection/$id',
    );
    final response = await http.get(
      url,
      headers: requestHeaders,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      //  List<Book> collectionListById = [];
      collectionListById = [];
      Map responsecollection = {};
      responsecollection = json.decode(response.body) as Map;
      var i = 0;
      responsecollection['books'].forEach((element) {
        Map? obj = element as Map;
        String image = responsecollection['md_ID'] as String;
        collectionListById.add(Book(
          bk_ID: obj['bk_ID'] as String,
          bk_Name: responsecollection['bc_Title'] as String,
          bk_Name_Ar: responsecollection['bc_Title_Ar'] as String,
          imagePath:
              'https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/$image',
          audioAr: '',
          audioEn: '',
          authors: [],
          categories: [],
          genres: [],
          publishers: [],
          tags: [],
          thematicAreas: [],
        ));
        i + 1;
      });

      await Get.toNamed<dynamic>(Routes.collection,
          arguments: collectionListById);
    } else {
      String ApiName = "GetEjazCollectionById";
      //await SendEmailException(response.body, ApiName);
      // throw Exception();
    }
  }

  //******************* Function Get UpdateProfiles  ******************//
  void UpdateProfiles(fullname, country, gender, bio) async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }
  if (gender == "null" ){gender = '';}
    Map<String, String> data = {
      "us_Gender": gender != "" ? gender.toString() : "unknow",
      "us_DisplayName": fullname != "" ? fullname.toString() : "unknow",
      "us_Language": "English",
      "us_DOB": "1995-08-13",
      // "Email": "hsinifghwalid@gmail.com",
      // "Username": "walid",
      // "PhoneNumber":"775885",
      //"bio": bio as String,
    };
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.updateprofile,
    );
    final response = await http.put(
      url,
      headers: requestHeaders,
      body: msg,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      print('profiles updated');
      mybox!.put('name', fullname.toString());
    } else {
      String ApiName = "UpdateProfiles";
      //  await SendEmailException(response.body, ApiName);
      print('profiles update error');

      // throw Exception();
    }
  }

  //******************* Function Get Checklogin  ******************//
// ignore_for_file: prefer_const_constructors
  CheckLogin(type, value, uid, displayName) async {
    
    print("type, value, uid, displayName $type, $value, $uid, $displayName");


    Map<String, String> data = {
      "email": type == 'google' ? value as String : "",
      "phoneNumber": type == 'phoneNumber' ? value as String : "",
      "username": type == 'apple' ? value as String : "",
    };
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      //'Host': '0',
      // 'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.checklogin,
    );
    final response = await http.post(
      url,
      headers: requestHeaders,
      body: msg,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      print("checklogin ${response.body}");
      if (response.body != "true") {
        await SignupGoogleApple(displayName as String, value as String,
            uid as String, type as String);
      } else {
        await SignGoogleApple(value as String, type as String);
      }
    } else {
      
      //String ApiName = "checklogin";
      //  await SendEmailException(response.body, ApiName);
      Get.rawSnackbar(
          messageText: const Text('Failed to connect !',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: ColorLight.primary,
          icon: const Icon(
            Icons.sentiment_very_dissatisfied,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
      var timer = Timer(Duration(seconds: 10), () => CloseRawSnakerbar());
      // throw Exception();
    }
  }

//******************* Function SignupGoogleApple  ******************//

  SignGoogleApple(String email, String type) async {
   
    // ignore: omit_local_variable_types
    Map<String, String> data = {
      "Password": 'GoogleApple@12345',
      "Email": email,
    };
    // ignore: prefer_final_locals
    int contentlength = utf8.encode(json.encode(data)).length;

    // ignore: omit_local_variable_types
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      //'Host': '0',
      // 'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.login,
    );
    final response = await http.post(url,
        headers: requestHeaders, body: msg); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      print('Login successful');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var data = response.body;
      final responsebody = json.decode(response.body) as Map<String, dynamic>;
      if (responsebody['isSubscribed'] == true) {
        await prefs.setString('name', responsebody['displayName'] as String);
        await prefs.setString("authorized", responsebody['token'] as String);
        await prefs.setString("image", responsebody['image'] as String);

        await FirebaseMessaging.instance.getToken().then((value) {
          print(value);
          String? token = value;
          prefs.setString('token', token!);
          UpdateFirebaseToken(token);
        });
        await mybox!.put('PaymentStatus', 'success');
     
        await Get.offNamed(Routes.home);
      }
      if (responsebody['isSubscribed'] == false) {
        await prefs.setString('name', responsebody['displayName'] as String);
        await prefs.setString("authorized", responsebody['token'] as String);
        await prefs.setString("image", responsebody['image'] as String);

        await FirebaseMessaging.instance.getToken().then((value) {
          print(value);
          String? token = value;
          prefs.setString('token', token!);
          UpdateFirebaseToken(token);
        });
        await mybox!.put('PaymentStatus', 'pending');
     
        await Get.offNamed(Routes.home);
      }
    } else {
      
      Get.rawSnackbar(
          messageText: const Text('Login Failed ... try again',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: ColorLight.primary,
          icon: const Icon(
            Icons.sentiment_very_dissatisfied,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
      var timer = Timer(Duration(seconds: 10), () => CloseRawSnakerbar());
    }
  }

  //******************* Function Get EjazCollectionById  ******************//
  PaymentPost(
      String pm_RefernceID, int pm_Price, int pm_Days, bool pm_Active) async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString('authorized');
    if (authorized == null || authorized == '') {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    Map<String, dynamic> data = {
      "pm_RefernceID": pm_RefernceID,
      "pm_Price": pm_Price,
      "pm_Days": pm_Days,
      "pm_Active": pm_Active,
      "pm_Result": 1,
    };
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.paymentdo,
    );
    final response = await http.post(
      url,
      body: msg,
      headers: requestHeaders,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      //  List<Book> collectionListById = [];
      var data = response.body;
      final responsebody = json.decode(response.body) as Map<String, dynamic>;
      if (responsebody['pm_Active'] == true) {
        mybox!.put('pm_Active', pm_Active);
        mybox!.put('pm_RefernceID', pm_RefernceID);
        mybox!.put('Sb_ID', responsebody['Sb_ID']);
        mybox!.put("pm_Price", pm_Price);
        mybox!.put("pm_Days", pm_Days);
        print("payment success");
        BooksApi().getBooks();
      }
    } else {
      // throw Exception();
    }
  }

//******************* Function Get GetBanner  ******************//

  void getBanner() async {
    late SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    Map<String, String> data = {};
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.banner,
    );
    final response = await http.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final responsebody = json.decode(response.body) as List<dynamic>;
      // await mybox!.put('getbanner', responsebody);
      List bannerList = [];
      bannerList = json.decode(response.body) as List;
      var i = 0;
      bannerList.forEach((element) {
        Map? obj = element as Map;
        getbannerList.add(BannerIm(
            bnid: obj['bn_ID'] as String,
            mdid: obj['md_ID'] as String,
            blID: obj['bl_ID'] as String,
            grID: obj['gr_ID'] as String,
            bnTitle: obj['bn_Title'] as String,
            bnTitleAr: obj['bn_Title_Ar'] as String,
            bnDesc: obj['bn_Desc'] as String,
            bnActive: obj['bn_Active'] as bool,
            bnDescAr: obj['bn_Desc_Ar'] as String,
            bnPublishFrom: obj['bn_PublishFrom'] as String,
            bnPublishTill: obj['bn_PublishTill'] as String,
            imagePath:
                "https://ejaz.applab.qa/api/ejaz/v1/Medium/getImage/${obj['md_ID']}"));
      });
    } else {
      // throw Exception();
    }
  }
}

//******************* Function Post Suggest book  ******************//
PostSuggest(String Bk_Code, String Bk_Title, String Bk_Language,
    String Bk_Author, String Bk_Editor, String Bk_Comments, String lang) async {
  late SharedPreferences sharedPreferences;
  sharedPreferences = await SharedPreferences.getInstance();
  String? authorized = sharedPreferences.getString("authorized");
  if (authorized == null || authorized == "") {
    authorized =
        'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
  }

  Map<String, String> data = {
    "Bk_Code": Bk_Code,
    "Bk_Title": Bk_Title,
    "Bk_Language": Bk_Language,
    "Bk_Author": Bk_Author,
    "Bk_Editor": Bk_Editor,
    "Bk_Comments": Bk_Comments,
  };
  int contentlength = utf8.encode(json.encode(data)).length;

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    //'Accept': 'application/json',
    'Content-Length': '$contentlength',
    //'Host': '0',
    'Authorization': 'Bearer $authorized'
  };
  final msg = jsonEncode(data);
  final url = Uri.parse(
    AppLink.suggest,
  );
  final response = await http.post(
    url,
    headers: requestHeaders,
    body: msg,
  ); //,headers: requestHeaders,

  if (response.statusCode == 200) {
    print('book sent');
    Get.snackbar(
      lang == "en" ? 'Alert' : 'تنبيه',
      lang == "en" ? 'Book sent successful' : 'الكتاب أرسِل بنجاح',
      colorText: Colors.white,
      backgroundColor: Colors.greenAccent,
      icon: const Icon(Icons.sentiment_satisfied_alt),
    );
  } else {
    String ApiName = "suggest book";
    //  await SendEmailException(response.body, ApiName);
    print('suggest book error');
    Get.snackbar(
      lang == "en" ? 'Alert' : 'تنبيه',
      lang == "en" ? 'Error,Please try again ' : 'خطأ، يرجى المحاولة مرة أخرى',
      colorText: Colors.white,
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.sentiment_satisfied_alt),
    );
    // throw Exception();
  }
}

//******************* Function Post GiftEjaz  ******************//
PostGiftEjaz(
  String fullname,
  String email,
  String typesub,
  String note,
  String lang,
) async {
  if (mybox!.get('PaymentStatus') == 'success') {
    late SharedPreferences sharedPreferences;

    sharedPreferences = await SharedPreferences.getInstance();
    String? authorized = sharedPreferences.getString("authorized");
    if (authorized == null || authorized == "") {
      authorized =
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNoYWhyYXouaUBvdXRsb29rLmNvbSIsIm5hbWVpZCI6IjUxN2Q3NmQ2LTg4MTYtNDljNS05YWU0LTM0YWFmNzQ3YmMxZCIsImVtYWlsIjoic2hhaHJhei5pQG91dGxvb2suY29tIiwibmJmIjoxNjkwNzM5NzYzLCJleHAiOjE2OTEzNDQ1NjMsImlhdCI6MTY5MDczOTc2M30.ox73qA-VWGjc2xJwYHEgDyWA031L6k4wh7t0KotIhhK0LMsVRYrf5ZS28ocRtd3HWo2idxgNzPKOzyAmFFAG0Q';
    }

    var pm_Price = mybox!.get("pm_Price") != null ? mybox!.get("pm_Price") : "";
    var pm_Days = mybox!.get("pm_Days") != null ? mybox!.get("pm_Days") : "";
    var pm_RefernceID =
        mybox!.get('pm_RefernceID') != null ? mybox!.get("pm_RefernceID") : "";
    var Sb_ID = mybox!.get('Sb_ID') != null ? mybox!.get("Sb_ID") : "";
    Map<String, String> data = {
      "Py_ID": "1e614759-be5c-4620-98d5-1dd079a120a6",
      "Sb_ID": Sb_ID,
      "PM_Recipient": email,
      "Pm_RefernceID": pm_RefernceID,
      "Pm_DisplayPrice": pm_Days,
      "Pm_Days": pm_Days,
      "Pm_Price": pm_Price,
      "Pm_Result": "1",
      "Pm_Ordinal": "1"
    };
    int contentlength = utf8.encode(json.encode(data)).length;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      //'Accept': 'application/json',
      'Content-Length': '$contentlength',
      //'Host': '0',
      'Authorization': 'Bearer $authorized'
    };
    final msg = jsonEncode(data);
    final url = Uri.parse(
      AppLink.giftejaz,
    );
    final response = await http.post(
      url,
      headers: requestHeaders,
      body: msg,
    ); //,headers: requestHeaders,

    if (response.statusCode == 200) {
      mybox!.put("pm_Price", '');
      mybox!.put("pm_Days", '');
      mybox!.put('pm_RefernceID', '');
      mybox!.put('Sb_ID', '');
      print('Gift ejaz sent');
      Get.snackbar(
        lang == "en" ? 'Alert' : 'تنبيه',
        lang == "en" ? 'Gift Ejaz sent successful' : 'هدية إيجاز أرسِلت بنجاح',
        colorText: Colors.white,
        backgroundColor: Colors.greenAccent,
        icon: const Icon(Icons.sentiment_satisfied_alt),
      );
    } else {
      String ApiName = "Gift ejaz";
      //  await SendEmailException(response.body, ApiName);
      print('Gift ejaz error');
      // throw Exception();
      Get.snackbar(
        lang == "en" ? 'Alert' : 'تنبيه',
        lang == "en"
            ? 'Gift payment has error! please try again '
            : 'خطأ في الهدية المدفوعة! حاول مجددًا',
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.info),
      );
    }
  } else {
    Get.snackbar(
      lang == "en" ? 'Alert' : 'تنبيه',
      lang == "en" ? 'Please subscribe first' : 'يرجى الاشتراك أولًا',
      colorText: Colors.white,
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.info),
    );
  }
}

// ignore: always_declare_return_types, inference_failure_on_function_return_type
CloseRawSnakerbar() {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
}

//*************  SendEmailException ******************/

// "ApiKey": "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", //EjazNotifier
// "SenderEmail": "fjalali@hbku.edu.qa",//downlaodejaz@gmail.com // password:Hbkupressendgrid@2024
// "SenderName": "Ejaz Admin"

// import 'package:sendgrid_mailer/sendgrid_mailer.dart';

// main() async {
//   final mailer = Mailer('<<YOUR_API_KEY>>');
//   final toAddress = Address('to@example.com');
//   final fromAddress = Address('from@example.com');
//   final content = Content('text/plain', 'Hello World!');
//   final subject = 'Hello Subject!';
//   final personalization = Personalization([toAddress]);

//   final email =
//       Email([personalization], fromAddress, subject, content: [content]);
//   mailer.send(email).then((result) {
//     // ...
//   });
// }

// ignore: always_declare_return_types, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, non_constant_identifier_names, type_annotate_public_apis
SendEmailException(body, ApiName) async {
  String username = 'downloadejaz@gmail.com';
  String password = 'Slah@2015*';

  final smtpServer = gmail(username, password);
  // Create our message.
  final message = Message()
    ..from = Address(username, 'Hsini Walid [web manager]')
    ..recipients.add('downloadejaz@gmail.com')
    ..subject = 'Mailer Exception :: 😀 :: ${DateTime.now()}'
    ..text = 'This is the plain text.\nThis is line 2 of the text part.'
    ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
  // Create a smtp client that will persist the connection

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  // Sending multiple messages with the same connection
  //
  var connection = PersistentConnection(smtpServer);
  // Send the first message
  await connection.send(message);
  // close the connection
  await connection.close();
}
