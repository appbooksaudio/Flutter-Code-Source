import 'dart:io';
import 'dart:typed_data';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:ejazapp/core/services/services.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/data/models/banner.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/pages/explore/authors.dart';
import 'package:ejazapp/pages/home/allcategory/all.dart';
import 'package:ejazapp/pages/home/biography/biography.dart';
import 'package:ejazapp/pages/home/business/business.dart';
import 'package:ejazapp/pages/home/culture/culture.dart';
import 'package:ejazapp/pages/home/groupes/my_groupes.dart';
import 'package:ejazapp/pages/home/health/health.dart';
import 'package:ejazapp/pages/home/history/history.dart';
import 'package:ejazapp/pages/home/novel/novel.dart';
import 'package:ejazapp/pages/home/politics/politics.dart';
import 'package:ejazapp/pages/home/science/science.dart';
import 'package:ejazapp/pages/home/self_developement/self_developement.dart';
import 'package:ejazapp/pages/order/slectplan.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/LoadingListPage.dart';
import 'package:ejazapp/widgets/become_menber.dart';
import 'package:ejazapp/widgets/book_card.dart';
import 'package:ejazapp/widgets/carsoul_bodcast.dart';
import 'package:ejazapp/widgets/custom_elevated_button.dart';
import 'package:ejazapp/widgets/search_widget.dart';
import 'package:ejazapp/widgets/stories_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ejazapp/pages/home/others/others.dart';
import 'package:uuid/uuid.dart';



class HomePage extends StatefulWidget {
  // ignore: always_put_required_named_parameters_first
  const HomePage({super.key, required this.controller});
  final BooksApi controller;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
      File? file;
        File? file1;
  late ConfettiController _controllerTopCenter;
  String? initialMessage;
  int? numNotification = 0;

  //late String? fullname = Get.arguments.toString();
  int countbanner = 0;
  ScrollController? _scrollViewController;
  late List<Book> books;
  late List<BannerIm> banner;
  String query = '';
  TabController? _tabController;
  bool isScrollingDown = false;
  late SharedPreferences prefs;
  String? name;
  @override
  void initState() {
    super.initState();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _scrollViewController = ScrollController();
    _tabController = TabController(length: 11, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
    });
    // books = mockBookList;
    Future.delayed(Duration.zero, () async {
      Provider.of<BooksApi>(context, listen: false).getBooks();
      Provider.of<BooksApi>(context, listen: false).getCategory();
      Provider.of<BooksApi>(context, listen: false).getAuthors();
      Provider.of<BooksApi>(context, listen: false).GetSubscription();
      Provider.of<BooksApi>(context, listen: false).GetEjazCollection();
      Provider.of<BooksApi>(context, listen: false).getBanner();
    });

    init();
    context.read<LocaleProvider>().initState();

// call firebase initnofification ////////////////
    initNotifications();

    //_controllerTopCenter.play();
  }
//****************************Start function showPopup() :  ************************/

//****************************Start function initNotifications() :  ************************/

  Future<void> initNotifications() async {
    final messaging = FirebaseMessaging.instance;

    final notificationSettings = await messaging.requestPermission();

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      const channel = AndroidNotificationChannel(
        'mychannel',
        'title',
        importance: Importance.max,
      );

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ejaz'),
          iOS: DarwinInitializationSettings(),
          // onSelectNotification: _onSelectNotification)
        ),
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification == null) {
          return;
        }
        setState(() {
          numNotification = numNotification! + 1;
        });
        final notification = message.notification!;
        var data = [];
        final priviousdata = mybox!.get('message');
        if (priviousdata != null) {
          data = mybox!.get('message') as List;
        }
        data.add([
          message.notification!.title,
          message.notification!.body,
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())
        ]);
        print('message Notification   $notification');

        mybox!.put('message', data);

        if (notification.android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
              ),
            ),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // do something with message
        print('A new onMessageOpenedApp event was published!');
        // Get.toNamed(Routes.notification, arguments: message);
        final notification = message.notification;
        var data = [];
        final priviousdata = mybox!.get('message');
        if (priviousdata != null) {
          data = mybox!.get('message') as List;
        }
        data.add([
          message.notification!.title,
          message.notification!.body,
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())
        ]);
        print('message Notification   $notification');

        mybox!.put('message', data);
        print('message Notification $notification');

        setState(() {
          numNotification = numNotification! + 1;
        });
      });

      await messaging.getInitialMessage().then((RemoteMessage? message) {
        if (message == null) {
          return;
        }
      });
    }
  }
//****************************End function initNotifications() :  ************************/

//**************************** function init() : set book list and show banner after 7 second ************************/
  Future init() async {
    setState(() {
      books = mockBookList;
      banner = getbannerList;
    });

    if (getbannerList.isNotEmpty) {
      Future.delayed(const Duration(seconds: 7), () {
        getbannerList[0].bnActive == true ? showPopup() : '';
      });
    }

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
        '$tempPath/image '+uid.split('-')[0]+'.jpeg'; // // file_01.tmp is dump file, can be anything
  return File(filePath)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

inittofile(ByteData bytesdata) async {
  try {
    file1 = await writeToFile(bytesdata) as File; // <= returns File
    setState(() {
      file =file1;
    });
  } catch (e) {
    // catch errors here
  }
}
//**************************** function _handleTabSelection() : ************************/

  void _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {});
    }
  }
//**************************** function searchBook() : ************************/

  void searchBook(String query) {
    final localprovider = Provider.of<LocaleProvider>(context, listen: false);
    final books = mockBookList.where((book) {
      final titleLower = localprovider.localelang!.languageCode == 'en'
          ? book.bk_Name!.toLowerCase()
          : book.bk_Name_Ar!.toLowerCase();
      // final authorLower = book.authors!.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower
          .contains(searchLower); //||authorLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.books = books;
    });
  }

  void showPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ignore: inference_failure_on_function_invocation
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              SizedBox(
                height: 40,
                child: Center(
                  child: FloatingActionButton(
                    elevation: 1,
                    foregroundColor: const Color.fromARGB(255, 237, 239, 242),
                    backgroundColor: ColorDark.background,
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close app',
                    child: const Icon(
                      Icons.close,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.only(
              top: 150,
              bottom: 100,
              left: 50,
              right: 50,
            ),
            content: Stack(
              // alignment: Alignment.center,
              children: <Widget>[
                Align(
                  child: ConfettiWidget(
                    confettiController: _controllerTopCenter,
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
                    ], // manually specify the colors to be used
                    // createParticlePath: drawStar, // define a custom shape/path.
                  ),
                ),
                Center(
                  child: Lottie.asset(
                    Const.backpopup,
                    // width: double.maxFinite,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: OctoImage(
                        image: CachedNetworkImageProvider(
                          getbannerList.length > 0
                              ? getbannerList[0].imagePath ?? Const.nodata
                              : Const.noarrival,
                        ),
                        fit: BoxFit.cover,
                        width: 150,
                        errorBuilder: OctoError.icon(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 280),
                    child: Text(
                      getbannerList.length > 0
                          ? getbannerList[0].bnTitle.toString()
                          : 'New arrival will be apear here',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 370,
                      left: 14,
                      right: 14,
                    ),
                    child: Text(
                      getbannerList.length > 0
                          ? getbannerList[0].bnDesc.toString()
                          : 'New arrival will be apear here',
                      style: const TextStyle(fontSize: 14, height: 1.2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  void dispose() {
    _scrollViewController!.dispose();
    _tabController!.dispose();
    // _controllerTopCenter.dispose();
    super.dispose();
  }

  List<Widget> _homeTabBarList(BuildContext context) => [
        Tab(text: AppLocalizations.of(context)!.all),
        Tab(text: AppLocalizations.of(context)!.biography),
        Tab(text: AppLocalizations.of(context)!.business),
        Tab(text: AppLocalizations.of(context)!.culture),
        Tab(text: AppLocalizations.of(context)!.health),
        Tab(text: AppLocalizations.of(context)!.history),
        Tab(text: AppLocalizations.of(context)!.politics),
        Tab(text: AppLocalizations.of(context)!.novel),
        Tab(text: AppLocalizations.of(context)!.science),
        Tab(text: AppLocalizations.of(context)!.self_developement),
        Tab(text: AppLocalizations.of(context)!.others),
      ];
//**************************** Start of function SearchWidget() : ************************/
  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: AppLocalizations.of(context)!.search_your_favorite_book,
        onChanged: searchBook,
      );
//**************************** End of function SearchWidget() : ************************/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        buildMainContent(context),
        buildCollapseAppBar(theme),
      ],
    );
  }

  Positioned buildCollapseAppBar(ThemeData theme) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: theme.colorScheme.background,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 19, right: 14),
            child: InkWell(
              onTap: () {
                Get.toNamed(Routes.notification);

                setState(() {
                  numNotification = 0;
                });
              },
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: -15, end: -12),
                badgeContent: Padding(
                  padding: localeProv.localelang!.languageCode == 'en'
                      ? const EdgeInsets.only(top: 5)
                      : const EdgeInsets.all(0),
                  child: Text(
                    '$numNotification',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                badgeAnimation: const badges.BadgeAnimation.slide(
                  curve: Curves.easeInCubic,
                ),
                child: Icon(
                  Feather.mail,
                  color: themeProv.isDarkTheme! ? Colors.grey : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: Const.margin),
        ],
      ),
    );
  }

  Positioned buildMainContent(BuildContext context) {
    var message = '';
    final Date = DateTime.now().hour;
    print('Date evning  $Date');
    if (Date >= 0 && Date <= 12) {
      message = AppLocalizations.of(context)!.good_morning;
    } else if (Date >= 13 && Date <= 18) {
      message = AppLocalizations.of(context)!.good_afternoon;
    } else if (Date >= 19 && Date <= 24) {
      message = AppLocalizations.of(context)!.good_evening;
    }

    final localeProv = Provider.of<LocaleProvider>(context);
    final displayname = mybox!.get('name');
    name = localeProv.localelang!.languageCode == 'en'
        ? displayname != null
            ? displayname as String
            : ""
        : '';
  

    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final isLoading = Provider.of<BooksApi>(context).isLooding;
    final localprovider = Provider.of<LocaleProvider>(context);
    final width = MediaQuery.of(context).size.width;
    return Positioned.fill(
      child: NestedScrollView(
        body: SingleChildScrollView(
          controller: _scrollViewController,
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //  const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(
                  left: Const.margin,
                  right: Const.margin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // '${AppLocalizations.of(context)!.good_morning} $name !',
                              '$message $name',
                              style: theme.textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 0),
                            Text(
                              AppLocalizations.of(context)!
                                  .today_is_a_new_day_for_knowledge,
                              style: theme.textTheme.headlineSmall!.copyWith(
                                color: themeProv.isDarkTheme!
                                    ? Colors.white54
                                    : Colors.black45,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 55,
                          width: 56,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: ((file == null)
                                ? const CachedNetworkImageProvider(
                                    'https://cdn.shopify.com/s/files/1/0747/0491/2661/files/profile.png?v=1691401880',
                                  )
                                : FileImage(file!)) as ImageProvider<Object>?,
                            backgroundColor: Colors.transparent,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
            //  const StoriesView(),
              // const SizedBox(height: 60),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: Const.margin),
                padding: const EdgeInsets.symmetric(horizontal: Const.margin),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(child: buildSearch()),
                  ],
                ),
              ),
              if (query.isEmpty)
                isLoading
                    ? const LoadingListPage()
                    : Column(
                        children: [
                          const SizedBox(height: 20),
                          buildSettingApp(
                            context,
                            title: AppLocalizations.of(context)!.recommended,
                            style: theme.textTheme.headlineLarge,
                            trailing:
                                localprovider.localelang!.languageCode == 'en'
                                    ? const Icon(
                                        Feather.chevrons_right,
                                        color: ColorLight.primary,
                                      )
                                    : const Icon(
                                        Feather.chevrons_left,
                                        color: ColorLight.primary,
                                      ),
                            onTap: () {
                              Get.toNamed<dynamic>(
                                Routes.allitem,
                                arguments: ['', 'lastbook', ''],
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: theme.primaryColor,
                              labelColor: theme.primaryColor,
                              unselectedLabelColor: theme.disabledColor,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              labelStyle: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              tabs: _homeTabBarList(context),
                            ),
                          ),
                          Center(
                            child: const [
                              AllCategory(),
                              BiographyTab(),
                              BusinessTab(),
                              CultureTab(),
                              HealthTab(),
                              HistoryTab(),
                              PoliticsTab(),
                              NovelTab(),
                              ScienceTab(),
                              SelfDevelopent(
                                category: '',
                              ),
                              othersTab(),
                            ][_tabController!.index],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: Const.margin,
                              right: Const.margin,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                      image: AssetImage(Const.maskgrouphome),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 200,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          width: width * 0.8,
                                          child: ListTile(
                                            contentPadding: localprovider
                                                        .localelang!
                                                        .languageCode ==
                                                    'en'
                                                ? const EdgeInsets.only(
                                                    top: 15,
                                                    left: 12,
                                                  )
                                                : EdgeInsets.only(
                                                    top: 15,
                                                    right: width * 0.38,
                                                  ),
                                            title: Text(
                                              AppLocalizations.of(context)!
                                                  .quote_of_day,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18,
                                                height: 1.2,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 15,
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .the_true_sign,
                                                style: const TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  letterSpacing: 0,
                                                  wordSpacing: 1,
                                                  height: 1.2,
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: width * 0.43,
                                            left: 10,
                                            top: 18,
                                          ),
                                          child: MyRaisedButton(
                                            color: const Color(0xFF0088CE),
                                            width: width * 0.5,
                                            onTap: OpenApp,
                                            label: AppLocalizations.of(context)!
                                                .suggetion,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                         // BodcastCarsoule(),
                          const SizedBox(height: 25),
                          buildSettingApp(
                            context,
                            title:
                                AppLocalizations.of(context)!.continue_reading,
                            style: theme.textTheme.headlineLarge,
                            trailing:
                                localprovider.localelang!.languageCode == 'en'
                                    ? const Icon(
                                        Feather.chevrons_right,
                                        color: ColorLight.primary,
                                      )
                                    : const Icon(
                                        Feather.chevrons_left,
                                        color: ColorLight.primary,
                                      ),
                            onTap: () {
                              Get.toNamed<dynamic>(
                                Routes.allitem,
                                arguments: ['', 'lastbook', 'newejaz'],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 270,
                            child: ListView.builder(
                              itemCount: 23,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.only(left: Const.margin),
                              itemBuilder: (context, index) {
                                final book = mockBookList[index];
                                return BookCard(book: book);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(height: 15),
                          buildSettingApp(
                            context,
                            title:
                                AppLocalizations.of(context)!.self_developement,
                            style: theme.textTheme.headlineLarge,
                            trailing:
                                localprovider.localelang!.languageCode == 'en'
                                    ? const Icon(
                                        Feather.chevrons_right,
                                        color: ColorLight.primary,
                                      )
                                    : const Icon(
                                        Feather.chevrons_left,
                                        color: ColorLight.primary,
                                      ),
                            onTap: () {
                              Get.toNamed<dynamic>(
                                Routes.allitem,
                                arguments: ['', 'lastbook', 'Self Development'],
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          const SelfDevelopent(
                            category: '',
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(height: 20),
                          buildSettingApp(
                            context,
                            title: AppLocalizations.of(context)!.top_authors,
                            style: theme.textTheme.headlineLarge,
                            trailing:
                                localprovider.localelang!.languageCode == 'en'
                                    ? const Icon(
                                        Feather.chevrons_right,
                                        color: ColorLight.primary,
                                      )
                                    : const Icon(
                                        Feather.chevrons_left,
                                        color: ColorLight.primary,
                                      ),
                            onTap: () {
                              Get.toNamed<dynamic>(Routes.listauthors);
                            },
                          ),
                          const AuthorsExplore(),
                          const SizedBox(height: 0),
                          buildSettingApp(
                            context,
                            title: AppLocalizations.of(context)!.mygroupes,
                            style: theme.textTheme.headlineLarge,
                            trailing: Container(),
                            // localprovider.localelang!.languageCode == 'en'
                            //     ? const Icon(
                            //         Feather.chevrons_right,
                            //         color: ColorLight.primary,
                            //       )
                            //     : const Icon(
                            //         Feather.chevrons_left,
                            //         color: ColorLight.primary,
                            //       ),

                            onTap: () {},
                          ),
                          const SizedBox(height: 2),
                          const MyGroupes(),
                         // const SizedBox(height: 20),
                         // const BecomeMenber(),
                          const SizedBox(height: 60),
                          // const StoriesView(),
                          // const SizedBox(height: 60),
                        ],
                      )
              else
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];

                      return buildBook(book);
                    },
                  ),
                ),
            ],
          ),
        ),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: theme.colorScheme.background,
              pinned: true,
              centerTitle: true,
            ),
          ];
        },
      ),
    );
  }

  Widget buildBook(Book book) {
    final localprovider = Provider.of<LocaleProvider>(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: () {
        if (book.bk_trial! != true) {
          PaymentDo(context);
          return;
        }
        Get.toNamed<dynamic>(
          Routes.bookdetail,
          arguments: [book, '', localprovider.localelang!.languageCode],
        );
      },
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(2),
          child: Image.network(
            book.imagePath,
            fit: BoxFit.cover,
            width: 70,
            height: 70,
          ),
        ),
        title: Text(
          localprovider.localelang!.languageCode == 'en'
              ? book.bk_Name!
              : book.bk_Name_Ar!,
          style: TextStyle(
            height: 1.3,
            color: themeProv.isDarkTheme! ? Colors.white : ColorDark.background,
          ),
        ),
        // subtitle: Text(book.authors!),
      ),
    );
  }

  void slidersOnTap() {}
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
  final theme = Theme.of(context);
  return InkWell(
    onTap: onTap,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: themeProv.isDarkTheme! ? Colors.white : Colors.black,
        ),
        // const SizedBox(width: 15),
        Expanded(child: Text(title, style: style)),
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 6, right: 6),
          child: trailing!,
        )
      ],
    ),
  );
}


