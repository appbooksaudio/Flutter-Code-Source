import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class UploadedAvatar extends StatefulWidget {
  const UploadedAvatar({super.key});

  @override
  State<UploadedAvatar> createState() => _UploadedAvatarState();
}

class _UploadedAvatarState extends State<UploadedAvatar> {
  File? _file;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            elevation: 0,
            height: Platform.isIOS ? 100 : 85,
            child: getStartedButton()),
        body: NestedScrollView(
          body: Stack(children: [
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(top: 120.0, left: 25, right: 25),
              child: RotatedBox(
                quarterTurns:
                    localeProv.localelang!.languageCode == 'ar' ? 2 : 0,
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 50,
                  lineHeight: 6.0,
                  percent: 1,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  backgroundColor: Colors.grey,
                  progressColor: ColorLight.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Text(
                AppLocalizations.of(context)!.choose_avatar,
                style: theme.textTheme.headlineLarge!.copyWith(fontSize: 28),
                textAlign: TextAlign.center,
              ), //
            ),
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.only(top: 70.0, left: 10, right: 10),
                child: Text(
                  AppLocalizations.of(context)!.select_profile_photo,
                  style: theme.textTheme.headlineLarge!.copyWith(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.start,
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 160.0),
              child: Column(children: <Widget>[
                const SizedBox(height: 50),
                const Divider(height: 0),
                const SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: ((_file == null)
                              ? const CachedNetworkImageProvider(
                                  'https://cdn.shopify.com/s/files/1/0747/0491/2661/files/profile.png?v=1691401880',
                                )
                              : FileImage(_file!)) as ImageProvider<Object>?,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: getImage,
                          child: CircleAvatar(
                            radius: 17,
                            backgroundColor: theme.primaryColor,
                            child: const Icon(
                              Feather.edit_2,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
          ]),
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

  SizedBox getStartedButton() {
    var goto = mybox!.get('preference');
    return SizedBox(
      height: 45,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 5, bottom: 10, left: 30.0, right: 30),
        child: MyRaisedButton(
          height: 100,
          width: 50,
          label: AppLocalizations.of(context)!.finish,
          onTap: () async {
            goto == 'home'
                // ignore: inference_failure_on_function_invocation
                ? Get.offAllNamed(Routes.home)
                : Get.toNamed(Routes.signinwithemail);

            await mybox!.put('preference', "");
            goto = "";
          },
        ),
      ),
    );
  }

  Future<dynamic> getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _file = File(pickedImage.path);
        Uint8List bytes = _file!.readAsBytesSync();
        mybox!.put('photo', bytes);
        print('Bytes ===========$bytes');
        mybox!.put('path', pickedImage.path);
      } else {
        // print('No Image Selected');
      }
    });
  }
}
