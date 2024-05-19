import 'package:ejazapp/controllers/auth/updatepassword.dart';
import 'package:ejazapp/core/class/handlingdataView.dart';
import 'package:ejazapp/core/functions/validInput.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UpdatePasswrod extends StatefulWidget {
  const UpdatePasswrod({super.key});

  @override
  State<UpdatePasswrod> createState() => _UpdatePasswrodtState();
}

class _UpdatePasswrodtState extends State<UpdatePasswrod> {
  bool obscureText = true;
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
    Get.put(UpdatePasswordControllerImp());
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        body: NestedScrollView(
      body: GetBuilder<UpdatePasswordControllerImp>(
          builder: (controller) => HandlingDataRequest(
              statusRequest: controller.statusRequest,
              widget: SingleChildScrollView(
                child: Form(
                  key: controller.formstatekey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            AppLocalizations.of(context)!.create_new_password,
                            style: theme.textTheme.labelMedium!.copyWith(
                                color: themeProv.isDarkTheme!
                                    ? Colors.white
                                    : ColorDark.background,
                                fontSize: 22),
                          ),
                          const SizedBox(height: 25),
                          buildTextField(
                            obscureText: obscureText,
                            onChanged: (value) {
                              controller.formstatekey.currentState!.validate();
                            },
                            valid: (val) {
                              return validInput(val!, 3, 40, 'password');
                            },
                            context,
                            mycontroller: controller.currentpassword,
                            label:
                                AppLocalizations.of(context)!.current_password,
                            icon: Feather.lock,
                            hintText: AppLocalizations.of(context)!
                                .please_fill_in_the_current_password,
                            isPassword: true,
                          ),
                          const SizedBox(height: 25),
                          buildTextField(
                            obscureText: obscureText,
                            onChanged: (value) {
                              // controller.formstatekey.currentState!.validate();
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
                            mycontroller: controller.newpassword,
                            label: AppLocalizations.of(context)!.password_new,
                            icon: Feather.lock,
                            hintText: AppLocalizations.of(context)!
                                .enter_new_password,
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
                            onChanged: (value) {},
                            valid: (val) {
                              // if (val!.isEmpty) return 'Empty';
                              if (val != controller.confirmpassword.text) {
                                return 'Password Not Match confirm ';
                              }
                              return null;
                            },
                            mycontroller: controller.confirmpassword,
                            context,
                            label: AppLocalizations.of(context)!
                                .password_confirmation,
                            icon: Feather.lock,
                            hintText: AppLocalizations.of(context)!
                                .enter_password_confirmation,
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: MyRaisedButton(
                              label: AppLocalizations.of(context)!.reset,
                              color: ColorLight.primary,
                              onTap: () => controller
                                  .updatepass(), //Routes.signupaddress
                            ),
                          ),
                        ]),
                  ),
                ),
              ))),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
              backgroundColor: theme.colorScheme.background,
              foregroundColor:
                  themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
              actions: [
                IconButton(
                  color: themeProv.isDarkTheme!
                      ? ColorLight.primary
                      : ColorLight.primary,
                  icon: Icon(
                    Icons.close,
                    color: themeProv.isDarkTheme!
                        ? ColorLight.primary
                        : ColorLight.primary,
                  ),
                  tooltip: 'Close',
                  onPressed: () => Get.toNamed<dynamic>(Routes.home),
                ),
              ],
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: true),
        ];
      },
    ));
  }

  void iconVisibilityOnTap() {
    setState(() {
      obscureText = !obscureText;
    });
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
          cursorColor: Colors.black,
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
}
