import 'package:ejazapp/controllers/auth/login_controller.dart';
import 'package:ejazapp/core/class/handlingdataView.dart';
import 'package:ejazapp/core/functions/validInput.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignInWithEmailPage extends StatefulWidget {
  const SignInWithEmailPage({super.key});
  @override
  State<SignInWithEmailPage> createState() => _SignInWithEmailPageState();
}

class _SignInWithEmailPageState extends State<SignInWithEmailPage> {
  late TextEditingController? logincontroller;
  bool obscureText = true;
  // Toggles the password show status

  @override
  Widget build(BuildContext context) {
    Get.put(LoginControllerImp());
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: PrivacyPolicy(),
          elevation: 0,
          height: 80,
        ),
        body: NestedScrollView(
          body: GetBuilder<LoginControllerImp>(
              builder: (controller) => HandlingDataRequest(
                    statusRequest: controller.statusRequest,
                    widget: SingleChildScrollView(
                      child: Form(
                        key: controller.formstate,
                        child: Column(
                          children: [
                            buildMainSection(
                              context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.log_in,
                                      style: theme.textTheme.headlineMedium!
                                          .copyWith(
                                        color: themeProv.isDarkTheme!
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const SizedBox(height: 40),
                                  buildTextField(
                                    valid: (val) {
                                      return validInput(val!, 3, 40, 'email');
                                    },
                                    logincontroller: controller.email,
                                    context,
                                    label: AppLocalizations.of(context)!
                                        .email_address,
                                    icon: Feather.mail,
                                    hintText: AppLocalizations.of(context)!
                                        .enter_email_address,
                                  ),
                                  const SizedBox(height: 25),
                                  buildTextField(
                                    obscureText: obscureText,
                                    valid: (val) {
                                      return validInput(
                                          val!, 3, 40, 'password');
                                    },
                                    logincontroller: controller.password,
                                    context,
                                    label:
                                        AppLocalizations.of(context)!.password,
                                    icon: Feather.lock,
                                    hintText: AppLocalizations.of(context)!
                                        .enter_your_password,
                                    isPassword: true,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () => Get.toNamed<dynamic>(
                                              Routes
                                                  .selectphoneemail, //resetpassword, //
                                              arguments:
                                                  "reset"), //Routes.forgotpassword
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .forgot_password,
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color: theme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ]),
                                  const SizedBox(height: 15),
                                ],
                              ),
                              button: MyRaisedButton(
                                label:
                                    AppLocalizations.of(context)!.log_in_button,
                                color: ColorLight.primary,
                                onTap: () => controller.login(),
                                // }),
                                //
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  )),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                  backgroundColor: theme.colorScheme.background,
                  foregroundColor:
                      themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.offAllNamed<dynamic>('signin'),
                  ),
                  pinned: true,
                  centerTitle: true,
                  automaticallyImplyLeading: true),
            ];
          },
        ));
  }

  SizedBox buildMainSection(
    BuildContext context, {
    required Widget button,
    Widget? child,
  }) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return SizedBox(
      width: double.infinity,
      height: 480,
      child: Stack(
        children: [
          ClipPath(
            // clipper: BottomContainerClipper(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                Const.margin,
                50,
                Const.margin,
                0,
              ),
              color: themeProv.isDarkTheme! ? Colors.transparent : Colors.white,
              child: child,
            ),
          ),
          Positioned(
            left: 50,
            right: 50,
            bottom: 20,
            child: button,
          ),
        ],
      ),
    );
  }

  Column buildTextField(
    BuildContext context, {
    required String label,
    String? hintText,
    IconData? icon,
    bool obscureText = false,
    required final String? Function(String?) valid,
    bool isPassword = false,
    // ignore: always_put_required_named_parameters_first
    required TextEditingController? logincontroller,
  }) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        TextFormField(
          validator: valid,
          controller: logincontroller,
          cursorColor: themeProv.isDarkTheme! ? Colors.white : Colors.black,
          obscureText: obscureText,
          style: theme.textTheme.titleLarge!.copyWith(
            color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          keyboardType:
              isPassword ? TextInputType.text : TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
            ),
            contentPadding: EdgeInsets.only(top: isPassword ? 15.0 : 0.0),
            icon: Icon(
              icon,
              color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
            ),
            suffixIcon: isPassword
                ? InkWell(
                    onTap: _toggle,
                    child: Icon(
                      obscureText ? Feather.eye_off : Feather.eye,
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                    ),
                  )
                : null,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void googleSignInOnTap() {
    showToast(
      msg: AppLocalizations.of(context)!.google_sign_in_tapped,
      backgroundColor: const Color(0xFFDD4B39),
    );
  }

  void facebookSignInOnTap() {
    showToast(
      msg: AppLocalizations.of(context)!.facebook_sign_in_tapped,
      backgroundColor: const Color(0xFF5C94D4),
    );
  }

  Column PrivacyPolicy() {
    final theme = Theme.of(context);
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.by_sign_in_i_accept,
              style: theme.textTheme.headlineSmall!.copyWith(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.privacypolicy),
              child: Text(
                AppLocalizations.of(context)!.terms_of_Service,
                style: theme.textTheme.headlineSmall!
                    .copyWith(color: ColorLight.primary, fontSize: 10),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .and_community_guidelines_and_have_read,
              style: theme.textTheme.headlineSmall!.copyWith(
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.privacypolicy),
              child: Text(
                AppLocalizations.of(context)!.privacy_policy,
                style: theme.textTheme.headlineSmall!
                    .copyWith(color: ColorLight.primary, fontSize: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
