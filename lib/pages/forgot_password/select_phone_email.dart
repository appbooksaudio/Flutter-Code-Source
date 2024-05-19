import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SelectPhoneEmail extends StatefulWidget {
  const SelectPhoneEmail({super.key});

  @override
  State<SelectPhoneEmail> createState() => _SelectPhoneEmailState();
}

class _SelectPhoneEmailState extends State<SelectPhoneEmail> {
  late bool _isButtonDisabled;
  dynamic argumentData = Get.arguments;

  @override
  void initState() {
    // TODO: implement initState
    _isButtonDisabled = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Const.margin),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.forgot_your_password,
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              AppLocalizations.of(context)!.select_of_the_following,
              textAlign: TextAlign.start,
              style: theme.textTheme.bodyLarge,
            ),
            // const SizedBox(height: 25),
            // Image.asset(
            //   Const.email,
            //   width: MediaQuery.of(context).size.width / 1.5,
            // ),
            const SizedBox(height: 150),
            MyRaisedButton(
              onTap: () => Get.toNamed<dynamic>(Routes.mobilenumberpage,
                  arguments: argumentData),
              label: AppLocalizations.of(context)!.mobile_number,
              color: ColorLight.primary,
              height: 55,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
            const SizedBox(height: 20),
            MyRaisedButton(
              onTap: () => _isButtonDisabled
                  ? null
                  : Get.toNamed<dynamic>(Routes.forgotpassword,
                      arguments: argumentData),
              label: AppLocalizations.of(context)!.emailreset,
              color: ColorLight.primary,
              height: 55,
              width: MediaQuery.of(context).size.width * 0.7,
            )
          ],
        ),
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
              backgroundColor: theme.colorScheme.background,
              foregroundColor:
                  themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: backOnTap,
              ),
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: true),
        ];
      },
    ));
  }

  void backOnTap() {
    Get.back<dynamic>();
  }

  void sendVerificationCodeOnTap() {}
}
