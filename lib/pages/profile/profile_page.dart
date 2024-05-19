import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/data/models/AppData.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
File? file; 
File? file1; 
@override
   void initState() {
    super.initState();
    // TODO: implement setState
   final data = mybox!.get('photo');
    if (data != null) {
      final bytesdata = ByteData.view(data.buffer as ByteBuffer);
      inittofile(bytesdata);
    }
  }

     writeToFile(ByteData data) async {
     var uid = Uuid().v4();
    final buffer = data.buffer;
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final filePath =
        '$tempPath/image '+uid.split('-')[0]+'.jpeg'; // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

   inittofile(ByteData bytesdata) async {
    try {
     file1 = await writeToFile(bytesdata) as File; // <= returns File
     setState(() {
       file =file1;
     });
      print("file   $file");
    } catch (e) {
      print(e);
       // catch errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final name = mybox!.get('name');
    final paymentSatus = mybox!.get('PaymentStatus');

    return NestedScrollView(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              // color: themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        final name = mybox!.get('name');
                        if (name == 'Guest') {
                          Get.showSnackbar(GetSnackBar(
                            title: 'Ejaz',
                            message: AppLocalizations.of(context)!
                                .messagetoguestuser,
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
                        Get.toNamed<dynamic>(Routes.settings);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: ((file == null)
                                ? const CachedNetworkImageProvider(
                                    'https://cdn.shopify.com/s/files/1/0747/0491/2661/files/profile.png?v=1691401880',
                                  )
                                : FileImage(file!)) as ImageProvider<Object>?,
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.toString(),
                                style: theme.textTheme.headlineLarge,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                paymentSatus == 'success'
                                    ? AppLocalizations.of(context)!
                                        .upgrad_account
                                    : AppLocalizations.of(context)!
                                        .free_account,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorLight.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // buildSettingApp(
                  //   context,
                  //   icon: Feather.award,
                  //   title: AppLocalizations.of(context)!.upgrade_premium_plan,
                  //   style: theme.textTheme.headlineMedium!.copyWith(
                  //       color: const Color.fromARGB(255, 225, 207, 42)),
                  //   trailing: const Icon(Icons.arrow_forward_ios),
                  //   onTap: () async {
                  //     final name = mybox!.get('name');
                  //     if (name == 'Guest') {
                  //       Get.showSnackbar(GetSnackBar(
                  //         title: 'Ejaz',
                  //         message:
                  //             AppLocalizations.of(context)!.messagetoguestuser,
                  //         duration: const Duration(seconds: 5),
                  //         titleText: Column(
                  //           children: [],
                  //         ),
                  //         snackPosition: SnackPosition.TOP,
                  //         backgroundColor: Colors.red,
                  //         icon: const Icon(Icons.mood_bad),
                  //       ));
                  //       return;
                  //     }
                  //     // await Get.toNamed<dynamic>(Routes.selectplan);
                  //     // RevenueCat().buyFirstSubscription();
                  //     // final product = await Purchases.purchaseProduct(
                  //     //     'bks_premium_month:booksummaries-month');
                  //     // print(product);

                  //     try {
                  //       var offerings = await Purchases.getOfferings();
                  //       if (offerings.current != null &&
                  //           offerings.current!.availablePackages.isNotEmpty) {
                  //         // Display current offering with offerings.current
                  //         // final offer = offerings.first;
                  //         // ignore: inference_failure_on_function_invocation, use_build_context_synchronously
                  //         await showModalBottomSheet(
                  //           useRootNavigator: true,
                  //           isDismissible: true,
                  //           isScrollControlled: true,
                  //           backgroundColor: ColorDark.background,
                  //           shape: const RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.vertical(
                  //               top: Radius.circular(25),
                  //             ),
                  //           ),
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return StatefulBuilder(
                  //               builder: (
                  //                 BuildContext context,
                  //                 StateSetter setModalState,
                  //               ) {
                  //                 return Paywall(
                  //                   offering: offerings.current!,
                  //                 );
                  //               },
                  //             );
                  //           },
                  //         );
                  //       } else {
                  //         Get.snackbar(
                  //           'Ejaz',
                  //           'No Subscription',
                  //           snackPosition: SnackPosition.TOP,
                  //         );
                  //       }
                  //     } on PlatformException catch (e) {
                  //       Get.snackbar(
                  //         'Ejaz',
                  //         e.toString(),
                  //         snackPosition: SnackPosition.TOP,
                  //       );
                  //       print(e);
                  //       // optional error handling
                  //     }
                  //   },
                  // ),
                 // const SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: Container(
                color: themeProv.isDarkTheme!
                    ? const Color(0xFF1F2937)
                    : const Color.fromARGB(255, 244, 244, 244),
                alignment: localeProv.localelang!.languageCode == 'ar'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: localeProv.localelang!.languageCode == 'ar'
                      ? const EdgeInsets.only(right: 20)
                      : const EdgeInsets.only(top: 8, left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.account_setting,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              // color: themeProv.isDarkTheme! ? ColorDark.card : Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  buildSettingApp(
                    context,
                    icon: Feather.star,
                    title: AppLocalizations.of(context)!.preference,
                    style: theme.textTheme.titleLarge,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.selectcategory);
                      mybox!.put('preference', 'home');
                    },
                  ),
                  // name != "Guest"
                  //     ? const SizedBox(height: 20)
                  //     : SizedBox(height: 0),
                  // name != "Guest"
                  //     ? buildSettingApp(
                  //         context,
                  //         icon: Feather.phone,
                  //         title: AppLocalizations.of(context)!.phone_number,
                  //         style: theme.textTheme.titleLarge,
                  //         trailing: const Icon(Icons.arrow_forward_ios),
                  //         onTap: () {
                  //           Get.toNamed<dynamic>(Routes.mobilenumberpage);
                  //         },
                  //       )
                  //     : Text(''),
                  name != "Guest"
                      ? const SizedBox(height: 20)
                      : SizedBox(height: 0),
                  name != "Guest"
                      ? buildSettingApp(
                          context,
                          icon: Feather.lock,
                          title: AppLocalizations.of(context)!.change_password,
                          style: theme.textTheme.titleLarge,
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Get.toNamed<dynamic>(Routes.updatepassword);
                          },
                        )
                      : SizedBox(height: 0),
                  name != "Guest"
                      ? const SizedBox(height: 20)
                      : SizedBox(height: 0),
                  SizedBox(
                    height: 40,
                    child: Container(
                      color: themeProv.isDarkTheme!
                          ? const Color(0xFF1F2937)
                          : const Color.fromARGB(255, 244, 244, 244),
                      alignment: localeProv.localelang!.languageCode == 'ar'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: localeProv.localelang!.languageCode == 'ar'
                            ? const EdgeInsets.only(right: 20)
                            : const EdgeInsets.only(top: 8, left: 20),
                        child: Text(
                          AppLocalizations.of(context)!.application,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildSettingApp(
                    context,
                    icon: Feather.download,
                    title: AppLocalizations.of(context)!.download_books,
                    style: theme.textTheme.titleLarge,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.listbook);
                    },
                  ),
                  const SizedBox(height: 20),
                  buildSettingApp(
                    context,
                    icon: Feather.heart,
                    title: AppLocalizations.of(context)!.favorite,
                    style: theme.textTheme.titleLarge,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.favorite);
                    },
                  ),
                  const SizedBox(height: 20),
                  buildSettingApp(
                    context,
                    icon: Feather.globe,
                    title: AppLocalizations.of(context)!.change_language,
                    style: theme.textTheme.titleLarge,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Get.toNamed<dynamic>(Routes.changeLanguageprofile);
                    },
                  ),
                  const SizedBox(height: 15),
                  buildSettingApp(
                    context,
                    icon: Feather.moon,
                    title: AppLocalizations.of(context)!.dark_mode,
                    style: theme.textTheme.titleLarge,
                    trailing: Switch(
                      value: themeProv.isDarkTheme!,
                      activeColor: theme.primaryColor,
                      inactiveTrackColor: theme.primaryColor,
                      onChanged: (val) {
                        themeProv.changeTheme();
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  buildSettingApp(
                    context,
                    icon: Feather.bell,
                    title: AppLocalizations.of(context)!.notification,
                    style: theme.textTheme.titleLarge,
                    trailing: Switch(
                      value: themeProv.isNotification!,
                      activeColor: theme.primaryColor,
                      inactiveTrackColor: theme.primaryColor,
                      onChanged: (val) {
                        themeProv.NotificationAcces();
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: localeProv.localelang!.languageCode == 'en'
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 40,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          final name = mybox!.get('name');
                          if (name == 'Guest') {
                            Get.showSnackbar(GetSnackBar(
                              title: 'Ejaz',
                              message: AppLocalizations.of(
                                      Get.context as BuildContext)!
                                  .messagetoguestuser,
                              duration: const Duration(seconds: 5),
                              titleText: Column(
                                children: [],
                              ),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              icon: const Icon(Icons.delete),
                            ));
                            return;
                          }
                          showDialog<dynamic>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: themeProv.isDarkTheme!
                                    ? ColorDark.card
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.are_you_sure,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall,
                                ),
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .if_you_select_log_out_it_will_return_to_the_delete_account,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      //  await ;
                                      final sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      await sharedPreferences.setString(
                                        'token',
                                        '',
                                      );
                                      await sharedPreferences.setString(
                                        'name',
                                        '',
                                      );
                                      await sharedPreferences.setString(
                                        'phone',
                                        '',
                                      );
                                      await sharedPreferences.setString(
                                        'authorized',
                                        '',
                                      );
                                      await mybox!
                                          .put('PaymentStatus', 'pending');
                                      await mybox!.put('name', '');
                                      await GoogleSignIn().signOut();
                                      await Get.offAllNamed<dynamic>(
                                        Routes.signin,
                                      );
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.yes,
                                      style: theme.textTheme.headlineSmall!
                                          .copyWith(
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back<dynamic>(),
                                    child: Text(
                                      AppLocalizations.of(context)!.no,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.delete_account,
                          style: const TextStyle(
                            height: 1.2,
                            fontFamily: 'Dubai',
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(Const.margin),
              child: MyRaisedButton(
                label: AppLocalizations.of(context)!.log_out,
                onTap: () {
                  showDialog<dynamic>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: themeProv.isDarkTheme!
                            ? ColorDark.card
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.are_you_sure,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall,
                        ),
                        content: Text(
                          AppLocalizations.of(context)!
                              .if_you_select_log_out_it_will_return_to_the_login_screen,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              await GoogleSignIn().signOut();
                              //  await ;
                              final sharedPreferences =
                                  await SharedPreferences.getInstance();
                              await sharedPreferences.setString('token', '');
                              await sharedPreferences.setString('name', '');
                              await sharedPreferences.setString('phone', '');
                              mybox!.put('name', '');
                              await Get.offAllNamed<dynamic>(Routes.signin);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.yes,
                              style: theme.textTheme.headlineSmall!
                                  .copyWith(color: theme.primaryColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back<dynamic>(),
                            child: Text(
                              AppLocalizations.of(context)!.no,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: theme.colorScheme.background,
            foregroundColor: themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
            // backgroundColor: themeProv.isDarkTheme!
            //     ? ColorDark.background
            //     : Colors.white,
            pinned: true,
            centerTitle: true,
          ),
        ];
      },
    );
  }

  Container buildProfileItem(
    BuildContext context, {
    required String title,
    required String trailing,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Const.margin),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title, style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(trailing, style: theme.textTheme.titleLarge),
          ),
        ],
      ),
    );
  }

  InkWell buildSettingApp(
    BuildContext context, {
    required String title,
    TextStyle? style,
    IconData? icon,
    Widget? trailing,
    void Function()? onTap,
  }) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Const.margin),
        child: Row(
          children: [
            Icon(
              icon,
              color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: localeProv.localelang!.languageCode == 'en'
                    ? const EdgeInsets.only(top: 8)
                    : const EdgeInsets.all(0),
                child: Text(title, style: style),
              ),
            ),
            trailing!,
          ],
        ),
      ),
    );
  }


}

class RevenueCat {
  static Future<List<Offering>> fetchOfferss() async {
    print('fetchOffers()');
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    print('purchasePackage()');
    try {
      await Purchases.purchasePackage(package);

      return true;
    } catch (e) {
      print('error: $e');
      return false;
    }
  }

  buyFirstSubscription() async {
    print('[fetchOffers]');
    final offerings = await RevenueCat.fetchOfferss();
    if (offerings.isEmpty) {
      Get.snackbar('Ejaz', 'No Subscription', snackPosition: SnackPosition.TOP);
    } else {
      final offer = offerings.first;

      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();
      // print(packages);
      final purchaseResult = await RevenueCat.purchasePackage(packages[0]);
    }
  }
}

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({super.key, required this.offering});

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
   ConfettiController? _controllerTopCenter;
  static const entitlementID = 'Book Summaries';
  static const kTitleTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);
  static const footerTextAr =
      ' يصبح الاشتراك فعالًا عند التأكد من تسديد قيمة الباقة المختارة. ويُجدد الاشتراك تلقائيًا ما لم يُلغ خلال 24 ساعة من انتهاء صلاحيته. يمكن إلغاء الاشتراك في أي وقت باستخدام إعدادات حسابك. وعند الاشتراك يُسترد منك ما لم تقرأه من النسخة التجريبية المجانية.';

  static const footerText =
      'A purchase will be applied to your account upon confirmation of the amount selected. Subscriptions will automatically renew unless canceled within 24 hours of the end of the current period. You can cancel any time using your account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription.';
  @override
  void initState() {
    // TODO: implement initState
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter!.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localprovider = Provider.of<LocaleProvider>(context, listen: false);
    final themeProv = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      child: Wrap(
        children: <Widget>[
          Container(
            height: 70,
            width: double.infinity,
            decoration: const BoxDecoration(color: ColorDark.background),
            child: Center(
              child: Text(
                localprovider.localelang!.languageCode == 'en'
                    ? '✨ Ejaz Premium ✨'
                    : '✨ باقة إيجاز الممتازة ✨',
                style: kTitleTextStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                localprovider.localelang!.languageCode == 'en'
                    ? 'EJAZ Subscriptions Plan'
                    : 'حدِّد نوع الاشتراك',
                style: kTitleTextStyle,
              ),
            ),
          ),
          ListView.builder(
            itemCount: widget.offering.availablePackages.length,
            itemBuilder: (BuildContext context, int index) {
              final myProductList = widget.offering.availablePackages;
              return Card(
                color: ColorLight.primary,
                child: ListTile(
                  onTap: () async {
                    try {
                      final customerInfo =
                          await Purchases.purchasePackage(myProductList[index]);
                      appData.entitlementIsActive = customerInfo
                          .entitlements.all[entitlementID]!.isActive;
                      if (appData.entitlementIsActive == true) {
                        await mybox!.put('PaymentStatus', 'success');
                        Get.showSnackbar(
                          GetSnackBar(
                            title: 'Ejaz',
                            message:
                                'Your payment was successful. You can enjoy our premium features!',
                            duration: const Duration(seconds: 15),
                            titleText: Column(
                              children: [
                                ConfettiWidget(
                                  confettiController: _controllerTopCenter!,
                                  blastDirectionality: BlastDirectionality
                                      .explosive, // don't specify a direction, blast randomly
                                  shouldLoop:
                                      true, // start again as soon as the animation is finished
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple
                                  ],
                                ),
                              ],
                            ),
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green,
                            icon: const Icon(Icons.emoji_events),
                          ),
                        );

                        final planName = customerInfo
                            .entitlements.all[entitlementID]!.productIdentifier;
                        final pmRefernceid =
                            customerInfo.originalAppUserId.split(':')[1];
                        final pmPrice =
                            planName.split('_')[2] == 'year' ? 70 : 7;
                        final pmDays =
                            planName.split('_')[2] == 'year' ? 360 : 30;
                        const pmActive = true;
                        await BooksApi().PaymentPost(
                          pmRefernceid,
                          pmPrice,
                          pmDays,
                          pmActive,
                        );
                        // setState(() {});
                      } else {
                        Get.snackbar(
                          'Error',
                          'Payment Failed',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.redAccent,
                          icon: const Icon(Icons.payment),
                        );
                      }
                    } on PlatformException catch (e) {
                      Get.snackbar(
                        'Error',
                        e.message.toString() ?? 'Unknown error',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.redAccent,
                        icon: const Icon(Icons.payment),
                      );
                      print(e);
                    }

                    setState(() {});
                    Navigator.pop(context);
                  },
                  title: Text(
                    myProductList[index].storeProduct.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    myProductList[index].storeProduct.description,
                    style: TextStyle(
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.white,
                    ),
                  ),
                  trailing: Text(
                    myProductList[index].storeProduct.priceString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color:
                          themeProv.isDarkTheme! ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              );
            },
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                localprovider.localelang!.languageCode == 'en'
                    ? footerText
                    : footerTextAr,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
