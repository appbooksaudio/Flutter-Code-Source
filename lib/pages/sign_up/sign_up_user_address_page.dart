import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ejazapp/helpers/clippers.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:get/get.dart';

class SignUpUserAddressPage extends StatefulWidget {
  const SignUpUserAddressPage({super.key});
  @override
  State<SignUpUserAddressPage> createState() => _SignUpUserAddressPageState();
}

class _SignUpUserAddressPageState extends State<SignUpUserAddressPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMainSection(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.book_shop,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    AppLocalizations.of(context)!.address,
                    style: theme.textTheme.headlineLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 55,
                    height: 2,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 50),
                  buildTextField(
                    context,
                    label: AppLocalizations.of(context)!.phone_number,
                    icon: Feather.phone,
                    hintText:
                        AppLocalizations.of(context)!.enter_your_phone_number,
                  ),
                  const SizedBox(height: 25),
                  buildTextField(
                    context,
                    label: AppLocalizations.of(context)!.address,
                    icon: Feather.map_pin,
                    hintText: AppLocalizations.of(context)!.address,
                  ),
                  const SizedBox(height: 25),
                  buildTextField(
                    context,
                    label: AppLocalizations.of(context)!.city,
                    icon: Feather.home,
                    hintText: AppLocalizations.of(context)!.enter_your_city,
                  ),
                ],
              ),
              button: MyRaisedButton(
                label: AppLocalizations.of(context)!.register,
                color: Colors.black,
                onTap: () => Get.offAllNamed<dynamic>(Routes.home),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  SizedBox buildMainSection(
    BuildContext context, {
    required Widget button,
    Widget? child,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 550,
      child: Stack(
        children: [
          ClipPath(
            clipper: BottomContainerClipper(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                Const.margin,
                50,
                Const.margin,
                0,
              ),
              color: ColorLight.primary,
              child: child,
            ),
          ),
          Positioned(
            left: 50,
            right: 50,
            bottom: 0,
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
    bool isPassword = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        TextField(
          cursorColor: Colors.white,
          obscureText: isPassword,
          style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
          keyboardType:
              isPassword ? TextInputType.text : TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: theme.textTheme.bodyMedium!.copyWith(
              color: Colors.white70,
            ),
            contentPadding: EdgeInsets.only(top: isPassword ? 15.0 : 0.0),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            suffixIcon: isPassword
                ? InkWell(
                    onTap: iconVisibilityOnTap,
                    child: Icon(
                      _obscureText ? Feather.eye_off : Feather.eye,
                      color: Colors.white70,
                    ),
                  )
                : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void iconVisibilityOnTap() {
    setState(() {
      _obscureText = !_obscureText;
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
}
