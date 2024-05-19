import 'package:cached_network_image/cached_network_image.dart';
import 'package:ejazapp/data/models/podcast.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/widgets/podcast_video.dart';
import 'package:flutter/material.dart';

class BodcastItem extends StatelessWidget {
  const BodcastItem({super.key, required this.poscast, this.index});

  final Podcast? poscast;
  final index;

  @override
  Widget build(BuildContext context) {
    List<Color> color = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.blueAccent,
      Colors.black,
      Colors.amberAccent,
      Colors.greenAccent
    ];
    return Column(children: [
      GestureDetector(
        onTap: () {
          showAlertDialog(context);
        },
        child: Container(
          width: 220,
          height: 304,
          child: Card(
            color: color[index],
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 220,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(poscast!.imagePath),
                          fit: BoxFit.fill,
                        ),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(0)),
                      ),
                    ),
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: ColorDark.background.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Health & Nutrition",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 10),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Dan Savage",
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            "How to Deal With infidelity",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "39 min",
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                    color: Colors.white),
                              ),
                              Text(
                                "4 chapters",
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ]),
                  ),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            margin: EdgeInsets.all(10),
          ),
        ),
      ),
    ]);
  }

  showAlertDialog(BuildContext context) async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.only(left: 2, right: 2),
      insetPadding: EdgeInsets.only(
          bottom: height * 0.30, top: height * 0.10, left: 0, right: 0),
      title: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Podcast Video",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: ColorDark.background,
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      )),
      content: Container(
          width: width - 20, height: height, child: VideoPlayerScreen()),
      actions: [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(child: alert);
      },
    );
  }
}
