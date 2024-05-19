import 'package:easy_container/easy_container.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class MobileNumberPage extends StatefulWidget {
  static const id = 'AuthenticationScreen';

  const MobileNumberPage({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<MobileNumberPage> {
  dynamic argumentData = Get.arguments;
  String? phoneNumber;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
        body: NestedScrollView(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              AppLocalizations.of(context)!.send_verification,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.enter_mobile_number,
              style: theme.textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeProv.isDarkTheme!
                      ? Colors.white
                      : Color.fromARGB(255, 83, 82, 82),
                  fontSize: 14),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 15),
            EasyContainer(
              elevation: 0,
              borderRadius: 10,
              color: Colors.transparent,
              child: Form(
                key: _formKey,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: IntlPhoneField(
                    showCountryFlag: false,
                    dropdownTextStyle: const TextStyle(
                      //  color: Colors.black,
                      fontSize: 25,
                    ),
                    autofocus: true,
                    invalidNumberMessage: 'Invalid Phone Number!',
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    onChanged: (phone) => phoneNumber = phone.completeNumber,
                    initialCountryCode: 'QA',
                    flagsButtonMargin: const EdgeInsets.all(5),
                    flagsButtonPadding: const EdgeInsets.only(
                      right: 10,
                    ),
                    showDropdownIcon: false,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            EasyContainer(
              height: 70,
              color: ColorLight.primary,
              width: double.infinity,
              onTap: () async {
                var data = {"value": argumentData, "phone": phoneNumber};
                if (isNullOrBlank(phoneNumber) ||
                    !_formKey.currentState!.validate()) {
                  showSnackBar('Please enter a valid phone number!');
                } else {
                  Get.toNamed<dynamic>(Routes.otpview,
                      arguments: data); //otpverification
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  //"Resend New Code",
                  AppLocalizations.of(context)!.send_code,
                  style: theme.textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
              backgroundColor: theme.colorScheme.background,
              foregroundColor:
                  themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
              // backgroundColor: themeProv.isDarkTheme!
              //     ? ColorDark.background
              //     : Colors.white,
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: true),
        ];
      },
    ));
  }
}
