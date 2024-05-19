import 'package:audio_service/audio_service.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:ejazapp/data/datasource/remote/listapi/getdataserver.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/pages/add_post.dart';
import 'package:ejazapp/pages/explore/explore.dart';
import 'package:ejazapp/pages/home/home_page.dart';
import 'package:ejazapp/pages/play_list/create_show_list.dart';
import 'package:ejazapp/pages/profile/profile_page.dart';
import 'package:ejazapp/providers/audio_provider.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

class BottomNavPage extends StatefulWidget {
  final int initialIndex;

  const BottomNavPage({super.key, this.initialIndex = 0});
  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedIndex = 0;
  PageController? _pageController;

  final _navigatorKey = GlobalKey();
  bool? ShowIcon = false;
  bool? ckeckState = false;
  var Tabs = [];
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    refreshTabController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    final localeProv = Provider.of<LocaleProvider>(context);
    bool? ckeckState = false;
    ckeckState = Provider.of<MyState>(context, listen: true).isPlaying;

    return MiniplayerWillPopScope(
      onWillPop: () async {
        final NavigatorState navigator =
            _navigatorKey.currentState as NavigatorState;
        if (!navigator.canPop()) return true;
        navigator.pop();

        return false;
      },
      child: Scaffold(
       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           topRight: Radius.circular(100),
      //           bottomLeft: Radius.circular(100),
      //           bottomRight: Radius.circular(100),
      //           topLeft: Radius.circular(100))),
      //   child: const Icon(Icons.add,color: Colors.white,),
      //   onPressed: () {
      //   // Get.toNamed(Routes.addpost);
        
      //   },
      // ),
        body: Stack(children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            children: [
              HomePage(
                controller: BooksApi(),
              ),
              Explore(),
             // AddPost(),
              //ListBook(),
              Create_showList(),
              // OrderPage(),
              ProfilePage(),
            ],
          ),
          if (ckeckState!)
            Consumer<MyState>(builder: (context, player, child) {
              return StreamBuilder<SequenceState?>(
                  stream: player.player!.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;

                    if (state?.sequence.isEmpty ?? true) {
                      return const SizedBox();
                    }
                    final metadata = state!.currentSource!.tag as MediaItem;
                    return player.isPlaying!
                        ? Miniplayer(
                            // onDismissed: () => currentlyPlaying.value = null,
                            curve: Curves.easeOut,
                            minHeight: 65,
                            maxHeight: 65,
                            builder: (height, percentage) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                color: ColorDark.background,
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            child: Image.network(
                                                height: 50,
                                                metadata.artUri.toString(),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Text(
                                            metadata.title,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                height: 1.3),
                                          ),
                                        ),
                                      ],
                                    ),
                                    StreamBuilder<PlayerState>(
                                      stream: player.player!.playerStateStream,
                                      builder: (context, snapshot) {
                                        final playerState = snapshot.data;
                                        final processingState =
                                            playerState?.processingState;
                                        final playing = playerState?.playing;
                                        if (processingState ==
                                                ProcessingState.loading ||
                                            processingState ==
                                                ProcessingState.buffering) {
                                          return Container(
                                              // margin: const EdgeInsets.all(8.0),
                                              // width: 64.0,
                                              // height: 64.0,
                                              // child:
                                              //     const CircularProgressIndicator(),
                                              );
                                        } else if (playing != true) {
                                          return IconButton(
                                              icon:
                                                  const Icon(Icons.play_arrow),
                                              iconSize: 20.0,
                                              color: Colors.white,
                                              onPressed: player.player!.play);
                                        } else if (processingState !=
                                            ProcessingState.completed) {
                                          return IconButton(
                                              icon: const Icon(Icons.pause),
                                              color: Colors.white,
                                              iconSize: 20.0,
                                              onPressed: player.player!
                                                  .pause); //widget.player.pause);
                                        } else {
                                          return IconButton(
                                            icon: const Icon(Icons.replay),
                                            color: Colors.white,
                                            iconSize: 20.0,
                                            onPressed: () => player.player!
                                                .seek(Duration.zero,
                                                    index: player
                                                        .player!
                                                        .effectiveIndices!
                                                        .first),
                                          );
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      color: Colors.white,
                                      iconSize: 20.0,
                                      onPressed: () {
                                        setState(() {
                                          Provider.of<MyState>(context,
                                                  listen: false)
                                              .isPlaying = false;
                                          player.player!.dispose();
                                        });
                                      },
                                    )
                                  ],
                                ),
                              );
                            })
                        : Container();
                  });
            })
          else
            Container(),
        ]),
        bottomNavigationBar: BottomNavigationBar(
           type: BottomNavigationBarType.fixed,
    selectedItemColor: theme.primaryColor,
    unselectedItemColor: themeProv.isDarkTheme! ? ColorLight.background : ColorDark.card,
    currentIndex: _selectedIndex,
          backgroundColor:
              themeProv.isDarkTheme! ? ColorDark.card : ColorLight.background,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
              _pageController!.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
           },
          items: [
            BottomNavigationBarItem(
              icon: Container(
              padding: EdgeInsets.symmetric(vertical: 7),
             child: Icon( Feather.home) ),
              label: AppLocalizations.of(context)!.home
            ),
            BottomNavigationBarItem(
              icon:Container(
              padding: EdgeInsets.symmetric(vertical: 7),
             child: Icon(Feather.search) ),
              label:AppLocalizations.of(context)!.explore, 
            ),
            //  BottomNavigationBarItem(
            //   icon:Container(
            //   padding: EdgeInsets.symmetric(vertical: 7),
            //  child: Icon(Icons.add_circle_rounded) ),
            //   label:AppLocalizations.of(context)!.post,
             
            // ),
            
            BottomNavigationBarItem(
              icon: Container(
              padding: EdgeInsets.symmetric(vertical: 7),
             child: Icon(Icons.play_circle_outline) ) ,
              label: AppLocalizations.of(context)!.list,
             
            ),
            BottomNavigationBarItem(
              icon: Container(
              padding: EdgeInsets.symmetric(vertical: 7),
             child: Icon(Feather.user) ) ,
              label:AppLocalizations.of(context)!.profile, 
             
            ),
          ],
        ),
      ),
    );
  }

  void refreshTabController() {
    setState(() {
      _selectedIndex = widget.initialIndex;
    });
  }
}
