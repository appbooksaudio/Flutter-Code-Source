import 'dart:async';

import 'package:ejazapp/data/models/playlist.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/constants.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:ejazapp/widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Create_showList extends StatefulWidget {
  const Create_showList({super.key});

  @override
  State<Create_showList> createState() => _Create_showListState();
}

class _Create_showListState extends State<Create_showList> {
  PlayList? _playlistAu;
  String dropdownValue = 'One';
  // Timer? timer;
  @override
  void initState() {
    initHiveStorage();
    super.initState();
  }

  // ignore: always_declare_return_types, inference_failure_on_function_return_type
  initHiveStorage() async {
    var box = await Hive.openBox('playlist');
    var currentplaylist =
        box.get('playlist') != null ? box.get('playlist') : null;
    if (currentplaylist != null) {
      List<dynamic> Listolay = [];
      Listolay = currentplaylist as List<dynamic>;
      mockPlayList = Listolay.cast<PlayList>();
    }
    //  if (mounted) {
    // timer = new Timer.periodic(Duration(seconds: 10), (Timer t) => setState(() {}));
    // }
  }

  @override
  void dispose() {
    // Hive.close();
    // timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor:
            themeProv.isDarkTheme! ? ColorDark.background : Colors.white,
        body: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              // A flexible app bar
              SliverAppBar(
                backgroundColor: theme.colorScheme.background,
                foregroundColor:
                    themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
                leading: IconButton(
                    onPressed: () {
                      Get.offAllNamed(Routes.home);
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              SliverFillRemaining(
                child: mockPlayList.isNotEmpty
                    ? ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, left: 20, right: 20),
                            child: Row(
                              children: [
                                FloatingActionButton(
                                  elevation: 1,
                                  foregroundColor:
                                      Color.fromARGB(255, 237, 239, 242),
                                  backgroundColor: ColorLight.primary,
                                  onPressed: () {
                                    showBarModalBottomSheet(
                                      // isScrollControlled: true,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      expand: false,
                                      isDismissible: true,
                                      context: context,
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.1),
                                      builder: (context) => Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: AddAudio(),
                                      ),
                                    );
                                  },
                                  tooltip: 'add playlist',
                                  child: const Icon(
                                    Icons.add,
                                    size: 25,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                      AppLocalizations.of(context)!
                                          .addnewplayList,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: themeProv.isDarkTheme!
                                            ? Colors.white
                                            : ColorDark.background,
                                      )),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                            thickness: 1,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.63,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 8.0),
                              itemCount: mockPlayList.length,
                              itemBuilder: (context, index) {
                                final _playlistAu = mockPlayList[index];

                                return PlaylistCreate(_playlistAu);
                              },
                            ),
                          ),
                        ],
                      )
                    : EmptyWidget(
                        image: Const.searchfav,
                        title: AppLocalizations.of(context)!.no_play_audio,
                        subtitle:
                            AppLocalizations.of(context)!.new_play_list_yet,
                        secondaryLabelButton:
                            AppLocalizations.of(context)!.create_newList,
                        secondaryOnTap: () {},
                      ),
              )
            ]));
  }

  Widget PlaylistCreate(PlayList play) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return InkWell(
      //  onTap: () => Get.toNamed<dynamic>(Routes.addaudioplay, arguments: play),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListTile(
            textColor:
                themeProv.isDarkTheme! ? Colors.white : ColorDark.background,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                play.pl_image!,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  play.pl_title!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.toNamed<dynamic>(Routes.addaudioplay,
                              arguments: play);
                        },
                        icon: const Icon(
                          Icons.play_circle_fill_outlined,
                          color: ColorLight.primary,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: themeProv.isDarkTheme!
                            ? Colors.white
                            : ColorDark.background,
                      ),
                      onSelected: (String result) {
                        switch (result) {
                          case 'Edit':
                            print('Edit clicked');
                            Get.toNamed<dynamic>(Routes.addaudioplay,
                                arguments: play);
                            break;
                          case 'Delete':
                            print('Delete clicked');
                            // mockPlayList.removeWhere(
                            //     (item) => item.pl_id == play.pl_id!);
                            DeleteItem(play);
                            setState(() {});
                            break;
                          default:
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text(
                            AppLocalizations.of(context)!.edit,
                            style: TextStyle(
                              color: themeProv.isDarkTheme!
                                  ? Colors.white
                                  : ColorDark.background,
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(AppLocalizations.of(context)!.delete,
                              style: TextStyle(
                                color: themeProv.isDarkTheme!
                                    ? Colors.white
                                    : ColorDark.background,
                              )),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  // ignore: always_declare_return_types, inference_failure_on_function_return_type
  DeleteItem(PlayList play) async {
    List<dynamic> playlist = [];
    var box = await Hive.openBox('playlist');
    var currentplaylist =
        box.get('playlist') != null ? box.get('playlist') : null;
    if (currentplaylist != null) {
      playlist = currentplaylist as List<dynamic>;
      playlist.removeWhere((item) => item.pl_id == play.pl_id!);
      mockPlayList = playlist.cast<PlayList>();
      await addPlaylist(playlist: playlist, boxName: 'playlist');
    }
  }

  Future<void> addPlaylist(
      {required String boxName, required List<dynamic> playlist}) async {
    var box = await Hive.openBox(boxName);
    box.put(boxName, playlist);

    print("WALLPAPER ADICIONADO NO HIVE!");
    setState(() {});
  }
}

int i = 0;

class AddAudio extends StatefulWidget {
  const AddAudio({Key? key}) : super(key: key);

  @override
  State<AddAudio> createState() => _AddAudioState();
}

class _AddAudioState extends State<AddAudio> {
  TextEditingController? titleController = TextEditingController();
  TextEditingController? decriController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final usableHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double widthm = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Container(
      height: usableHeight * 0.4,
      color: themeProv.isDarkTheme! ? Colors.white : ColorDark.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              AppLocalizations.of(context)!.newplaylist,
              style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeProv.isDarkTheme! ? ColorDark.background : Colors.white),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
         
          Padding(
            padding: EdgeInsets.only(top: 30.0, left: 30, right: 30, bottom: 0),
            child: TextField(
              style: TextStyle(
                height: 1.5,
                color: themeProv.isDarkTheme!
                          ? ColorDark.background
                          : Colors.white,),
              cursorHeight: 15,
              cursorColor: Colors.black,
              cursorWidth: 2,
              textAlignVertical: TextAlignVertical.bottom,
              controller: titleController,
              decoration: InputDecoration(
                helperText: '30 characters',
                helperStyle: TextStyle(color: Colors.redAccent),
               // hintTextDirection: TextDirection.ltr,
                suffixStyle: TextStyle(color: Colors.green),
                filled: true,
                fillColor: Colors.transparent,
                focusColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: 
                        themeProv.isDarkTheme!
                          ? ColorDark.background
                          : Colors.white,
                      width: 0.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeProv.isDarkTheme!
                          ? ColorDark.background
                          : Colors.white,
                      width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: themeProv.isDarkTheme!
                          ? ColorDark.background
                          : Colors.white,
                      width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: AppLocalizations.of(context)!.playlisttitle,
                hintStyle: TextStyle(
                  height: 1.5,
                    color: themeProv.isDarkTheme!
                        ?  ColorDark.background
                          : Colors.white,
                    fontSize: 15),
              ),
            ),

          ),
          Padding(
            padding: EdgeInsets.only(
                top: 40.0, right: widthm * 0.1, left: widthm * 0.1, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: 150,
                  height: 45,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Color.fromARGB(255, 247, 132, 132),
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.cancels,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: 150,
                  height: 45,
                  onPressed: () {
                    Create(titleController!.text, decriController!.text);
                  },
                  color: ColorLight.primary,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      AppLocalizations.of(context)!.create,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ignore: always_declare_return_types, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter
  Create(tiltle, description) {
    List<String> image = [
      'https://media.gq.com/photos/5ae3925b3fb87856d8a5cdf6/16:9/w_2560%2Cc_limit/Road-Trip-Playlist-GQ-April-2018-042718-3x2.png',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8xvOvaj3HEInRtTuyiP3w-0vSjUJiLmOOIv5drPt9yZO_EyrvP5NMIzff5PvdHFrvEOQ&usqp=CAU',
      'https://www.shutterstock.com/shutterstock/photos/1795845130/display_1500/stock-vector-playlist-neon-sign-vector-music-playlist-neon-poster-design-template-modern-trend-design-night-1795845130.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTF7BwuQoEmL9Pf5TbLVffk9IihRWoh_GXAEf2zH3gV67KbB-6y9JJ8qR_EZ4a3gvf1dTo&usqp=CAU',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSM0M2smuq9Z-LiH3_2eNtGQlY12Per1sTspJsLDEEPmNK9PxANDwPqOKLQDjt77rwi-Kw&usqp=CAU',
      'https://i.pinimg.com/236x/73/09/9c/73099c7c86f104d494945192b885cb9f.jpg'
    ];
    String title = tiltle.toString().trim();
    String descrip = description.toString().trim();
    // Create uuid object
    final uuid = Uuid();
    if (i == 5) {
      i = 0;
    }
    if (title != '') {
      // mockPlayList.add(PlayList(
      //     pl_id: uuid.v1(), pl_title: title, pl_image: image[i], pl_audio: []));
      SavePlayListStorage(uuid.v1(), title, image[i]);

      Get.toNamed<dynamic>(Routes.createshowList);
      //  Navigator.pop(context);
      i++;
      // Navigator.pop(context);
    } else {
      Widget continueButton = TextButton(
        child: Text("ok"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text("Alert"),
        content: Text("Title is empty!!"),
        actions: [continueButton],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  // ignore: always_declare_return_types, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, non_constant_identifier_names, type_annotate_public_apis
  SavePlayListStorage(id, title, image) async {
    bool extis = false;
    List<dynamic> playlist = [];
    var box = await Hive.openBox('playlist');
    var currentplaylist =
        box.get('playlist') != null ? box.get('playlist') : null;
    if (currentplaylist != null) {
      playlist = currentplaylist as List<dynamic>;
      playlist.add(PlayList(
          pl_id: id as String,
          pl_title: title as String,
          pl_image: image as String,
          pl_audio: []));
      mockPlayList = playlist.cast<PlayList>();
      addPlaylist(playlist: playlist, boxName: 'playlist');
    } else {
      mockPlayList.add(PlayList(
          pl_id: id as String,
          pl_title: title as String,
          pl_image: image as String,
          pl_audio: []));
      List<dynamic> newList = [];
      newList.add(
          PlayList(pl_id: id, pl_title: title, pl_image: image, pl_audio: []));
      await addPlaylist(playlist: newList, boxName: 'playlist');
    }
  }

  Future<void> addPlaylist(
      {required String boxName, required List<dynamic> playlist}) async {
    var box = await Hive.openBox(boxName);
    box.put(boxName, playlist);

    print("WALLPAPER ADICIONADO NO HIVE!");
  }
}
