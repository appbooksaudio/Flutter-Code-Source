import 'package:ejazapp/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    required this.image,
    required this.subtitle,
    required this.title,
    this.labelButton,
    this.secondaryLabelButton,
    this.secondaryOnTap,
    super.key,
  });

  final String image;
  final String title;
  final String subtitle;
  final String? labelButton;
  final String? secondaryLabelButton;
  final void Function()? secondaryOnTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Lottie.asset(
            image,
            width: double.infinity,
            fit: BoxFit.cover,
          )),
          const SizedBox(height: 20),
          Text(title,
              style: theme.textTheme.headlineLarge!.copyWith(fontSize: 22)),
          const SizedBox(height: 15),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 20),
          if (labelButton != null)
            MyRaisedButton(
              onTap: () => Get.offAllNamed<dynamic>(Routes.home),
              label: labelButton,
            ),
          const SizedBox(height: 10),
          if (secondaryLabelButton != null)
            MyRaisedButton(
              onTap: () {
                final name = mybox!.get('name');
                if (name == 'Guest') {
                  Get.showSnackbar(GetSnackBar(
                    title: 'Ejaz',
                    message: AppLocalizations.of(context)!.messagetoguestuser,
                    duration: const Duration(seconds: 5),
                    titleText: Column(
                      children: [],
                    ),
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    icon: const Icon(Icons.mood_bad),
                  ));
                  return;
                }
                Get.toNamed<dynamic>(Routes.addplayList);
              },
              label: secondaryLabelButton,
              //color: const Color(0xFF8D92A3),
            )
          else
            Container(),
        ],
      ),
    );
  }
}
