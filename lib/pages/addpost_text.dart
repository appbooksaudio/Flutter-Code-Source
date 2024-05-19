import 'dart:io';

import 'package:ejazapp/data/models/firestor.dart';
import 'package:ejazapp/data/models/storage.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../helpers/routes.dart';

// ignore: must_be_immutable
class AddPostTextScreen extends StatefulWidget {
  File _file;
  var typeFile;
  AddPostTextScreen(this._file, this.typeFile, {super.key});

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final caption = TextEditingController();
  final location = TextEditingController();

  bool islooding = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeProv.isDarkTheme! ? Colors.white : ColorDark.background,
        ),
        backgroundColor:
            themeProv.isDarkTheme! ? ColorDark.background : Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.newpost,
          style: TextStyle(
            color: themeProv.isDarkTheme! ? Colors.white : ColorDark.background,
          ),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    islooding = true;
                  });
                  String post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file);
                  var duraion;
                  ;
                  if (widget.typeFile == 'video') {
                    VideoPlayerController controller =
                        await VideoPlayerController.file(widget._file);
                    await controller.initialize();
                    duraion = controller.value.duration.inSeconds;
                  }

                  await Firebase_Firestor().CreatePost(
                    postImage: post_url,
                    caption: caption.text,
                    location: "empty",
                    typeFile: widget.typeFile,
                    duration: duraion != null ? duraion.toString() : '3',
                  );
                  setState(() {
                    islooding = false;
                  });
                  // ignore: use_build_context_synchronously
                  // Navigator.of(context).pop();
                  Get.toNamed(Routes.home);

                  await Fluttertoast.showToast(
                    webPosition: 'center',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    fontSize: 12,
                    backgroundColor: ColorLight.primary,
                    textColor: Colors.white,
                    msg: "successfully added new Stories",
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.share,
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: islooding
              ? Center(
                  child: 
                  Container(
                    height: 30,
                    width: 300,
                    child: LiquidLinearProgressIndicator(
                      value: 0.75, // Defaults to 0.5.
                      valueColor: AlwaysStoppedAnimation(Colors.blue), // Defaults to the current Theme's accentColor.
                      backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                      borderColor: Colors.blue,
                      borderWidth: 5.0,
                      borderRadius: 12.0,
                      direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                      center: Text("Loading..."),
                    ),
                  ),
                //   CircularProgressIndicator(
                //   color: Colors.white,
                // )
                )
              : Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black, spreadRadius: 3),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'cairo'),
                                controller: caption,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      AppLocalizations.of(context)!.text_post,
                                  hintStyle: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.typeFile == 'image'
                              ? Container(
                                  width: double.infinity,
                                  height: height * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.amber,
                                    image: DecorationImage(
                                      image: FileImage(widget._file),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: height * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.amber,
                                  ),
                                  child: Image.network(
                                      'https://firebasestorage.googleapis.com/v0/b/ejaz-ca748.appspot.com/o/play.png?alt=media&token=67eacf65-63a8-4f84-8fdd-e84588b1b7ce'),
                                ),
                        ],
                      ),
                    ],
                  ),
                )),
    );
  }
}
