import 'package:ejazapp/controllers/auth/signup_controller.dart';
import 'package:ejazapp/core/class/handlingdataView.dart';
import 'package:ejazapp/core/functions/validInput.dart';
import 'package:ejazapp/helpers/clippers.dart';
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
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obscureText = true;
  late String _password;
  late TextEditingController? mycontroller;
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double password_strength = 0;

  //A function that validate user entered password
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (_password.isEmpty) {
      setState(() {
        password_strength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        password_strength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        password_strength = 2 / 4;
      });
    } else {
      if (pass_valid.hasMatch(_password)) {
        setState(() {
          password_strength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          password_strength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpControllerImp());
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
          body: GetBuilder<SignUpControllerImp>(
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
                                //  mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .create_an_account,
                                    style:
                                        theme.textTheme.headlineLarge!.copyWith(
                                      color: themeProv.isDarkTheme!
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  buildTextField(
                                    onChanged: (value) {},
                                    valid: (val) {
                                      return validInput(
                                          val!, 3, 20, 'username');
                                    },
                                    mycontroller: controller.username,
                                    context,
                                    label:
                                        AppLocalizations.of(context)!.username,
                                    icon: Feather.user,
                                    hintText: AppLocalizations.of(context)!
                                        .enter_full_name,
                                  ),
                                  const SizedBox(height: 25),
                                  buildTextField(
                                    onChanged: (value) {},
                                    valid: (val) {
                                      return validInput(val!, 3, 40, 'email');
                                    },
                                    mycontroller: controller.email,
                                    context,
                                    label: AppLocalizations.of(context)!
                                        .email_address,
                                    icon: Feather.mail,
                                    hintText: AppLocalizations.of(context)!
                                        .enter_your_email_address,
                                  ),
                                  const SizedBox(height: 25),
                                  buildTextField(
                                    obscureText: obscureText,
                                    onChanged: (value) {
                                      controller.formstate.currentState!
                                          .validate();
                                    },
                                    valid: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please enter password';
                                      } else {
                                        //call function to check password
                                        bool result = validatePassword(val);
                                        if (result) {
                                          // create account event
                                          return null;
                                        } else {
                                          return ' Password should contain Capital, small letter & Number & Special';
                                        }
                                      }
                                    },
                                    context,
                                    mycontroller: controller.password,
                                    label:
                                        AppLocalizations.of(context)!.password,
                                    icon: Feather.lock,
                                    hintText: AppLocalizations.of(context)!
                                        .enter_your_password,
                                    isPassword: true,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 40, right: 40),
                                    child: LinearProgressIndicator(
                                      value: password_strength,
                                      backgroundColor: Colors.grey[300],
                                      minHeight: 5,
                                      color: password_strength <= 1 / 4
                                          ? Colors.red
                                          : password_strength == 2 / 4
                                              ? Colors.yellow
                                              : password_strength == 3 / 4
                                                  ? Colors.blue
                                                  : Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  buildTextField(
                                    obscureText: obscureText,
                                    onChanged: (value) {
                                      controller.formstate.currentState!
                                          .validate();
                                    },
                                    valid: (val) {
                                      if (val!.isEmpty) return 'Empty';
                                      if (val != controller.password.text)
                                        return 'Passwords do not match';
                                      return null;
                                    },
                                    mycontroller: controller.confirmpassword,
                                    context,
                                    label: AppLocalizations.of(context)!
                                        .password_confirmation,
                                    icon: Feather.lock,
                                    hintText: AppLocalizations.of(context)!
                                        .enter_password_confirmation,
                                    isPassword: true,
                                  ),
                                ],
                              ),
                              button: MyRaisedButton(
                                  label: AppLocalizations.of(context)!.register,
                                  color: ColorLight.primary,
                                  onTap: () =>
                                      controller.signUp() //Routes.signUp
                                  ),
                            ),
                            const SizedBox(height: 60),
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
                  actions: [
                    IconButton(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.black,
                      icon: const Icon(Icons.close),
                      tooltip: 'Close',
                      onPressed: () => Get.toNamed<dynamic>(Routes.signin),
                    ),
                  ],
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
      height: 700,
      child: Stack(
        children: [
          ClipPath(
            clipper: BottomContainerClipper(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                Const.margin,
                20,
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
            bottom: 60,
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
    bool obscureText = false,
    IconData? icon,
    bool isPassword = false,
    required final String? Function(String?) valid,
    required TextEditingController? mycontroller,
    required Null Function(dynamic value) onChanged,
    String? type,
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
            style: theme.textTheme.bodyLarge!.copyWith(
              color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
            ),
          ),
        ),
        TextFormField(
          onChanged: onChanged,
          validator: valid,
          controller: mycontroller,
          cursorColor: themeProv.isDarkTheme! ? Colors.white : Colors.black,
          obscureText: obscureText,
          style: theme.textTheme.titleLarge!.copyWith(
            color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyLarge!.copyWith(
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
            // focusedBorder: const UnderlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.black,
            //   ),
            // ),
          ),
        ),
      ],
    );
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Column PrivacyPolicy() {
    final theme = Theme.of(context);
    return Column(
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

_launchURL() async {
  final Uri url =
      Uri.parse('https://ejaz.azurewebsites.net/privacy-policy.html');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
