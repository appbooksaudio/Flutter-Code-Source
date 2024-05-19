

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_stories/flutter_instagram_stories.dart';
import 'package:provider/provider.dart';

class StoriesView extends StatefulWidget {
  const StoriesView({super.key});

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {

  
static String collectionDbName = 'ejaz_stories_db';

  //TODO: add possibility get data from any API
  CollectionReference dbInstance =
      FirebaseFirestore.instance.collection(collectionDbName);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
     final themeProv = Provider.of<ThemeProvider>(context);
    return Container(
      height: 110,
       // color: Colors.indigo,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:15.0,right: 15),
              child: FlutterInstagramStories(
                collectionDbName: collectionDbName,
                showTitleOnIcon: false,
                backFromStories: () {
                  _backFromStoriesAlert();
                },
                iconTextStyle:  TextStyle(
                  fontSize: 10.0,
                  color:  themeProv.isDarkTheme! ? Colors.white : ColorDark.background,
                  fontWeight: FontWeight.bold,
                  height: 1
                ),
                iconImageBorderRadius: BorderRadius.circular(100),
                iconBoxDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xFFffffff),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff333333),
                      blurRadius: 10.0,
                      offset: Offset(
                        0.0,
                        4.0,
                      ),
                    ),
                  ],
                ),
                iconWidth: 70.0,
                iconHeight: 70.0,
                textInIconPadding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
                //how long story lasts in seconds
                imageStoryDuration: 7,
                progressPosition: ProgressPosition.top,
                repeat: true,
                inline: false,
                languageCode: 'en',
                backgroundColorBetweenStories: Colors.black,
                closeButtonIcon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28.0,
                ),
                closeButtonBackgroundColor: const Color(0x11000000),
                sortingOrderDesc: true,
                lastIconHighlight: true,
                lastIconHighlightColor: Colors.deepOrange,
                lastIconHighlightRadius: const Radius.circular(100.0),
                captionTextStyle: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
                captionMargin: const EdgeInsets.only(
                  bottom: 50,
                ),
                captionPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
              ),
            ),
          
          ],
        ),
      );
   
  }
  _backFromStoriesAlert() {
    // showDialog(
    //   context: context,
    //   builder: (_) => SimpleDialog(
    //     title: const Text(
    //       "User have looked stories and closed them.",
    //       style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0),
    //     ),
    //     children: <Widget>[
    //       SimpleDialogOption(
    //         child: const Text("Dismiss"),
    //         onPressed: () {
    //          Navigator.pop(context);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}