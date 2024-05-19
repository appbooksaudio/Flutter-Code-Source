import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  dynamic argumentData = Get.arguments;
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
            const SizedBox(
              height: 80,
            ),
            Text(
              AppLocalizations.of(context)!.forgot_your_password,
              style: theme.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              AppLocalizations.of(context)!
                  .enter_your_registered_email_below_to_receive_password_reset_authentication,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            // const SizedBox(height: 25),
            // Image.asset(Const.email,
            //   width: MediaQuery.of(context).size.width / 1.5,
            // ),
            const SizedBox(height: 25),
            TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.email_address,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Const.radius),
                  borderSide: BorderSide(
                    color: theme.disabledColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Const.radius),
                  borderSide: BorderSide(
                    color: theme.disabledColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            const SizedBox(height: 50),
            MyRaisedButton(
              onTap: sendVerificationCodeOnTap,
              label: AppLocalizations.of(context)!.send,
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

  void sendVerificationCodeOnTap() {
    Get.offAllNamed(Routes.otpverification, arguments: argumentData);
  }
}
