import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/pages/order/slectplan.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BecomeMenber extends StatelessWidget {
  const BecomeMenber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    var height =MediaQuery.of(context).size.height;
    return InkWell(
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
        PaymentDo(context);
      }, //Get.toNamed(Routes.selectplan),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: AssetImage(Const.becomemenber),
            fit: BoxFit.cover,
          ),
        ),
        height:height * 0.13,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.only(top:height * 0.04),
              child: Text(
                AppLocalizations.of(context)!.become_member,
                style: theme.textTheme.bodyMedium!.copyWith(
                    color: themeProv.isDarkTheme! ? Colors.white : Colors.white,
                    fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.upgrade_now_account,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontSize: 11,
                color: themeProv.isDarkTheme! ? Colors.white : Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
