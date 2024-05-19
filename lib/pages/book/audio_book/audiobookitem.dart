// ignore_for_file: unnecessary_statements

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/helpers/routes.dart';
import 'package:ejazapp/pages/book/audio_book/common.dart';
import 'package:ejazapp/providers/animation_test_play.dart';
import 'package:ejazapp/providers/audio_provider.dart';
import 'package:ejazapp/providers/download_provider.dart';
import 'package:ejazapp/providers/locale_provider.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as prefix;
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class AudioBook extends StatefulWidget {
  // const AudioBook({super.key});

  @override
  AudioBookState createState() => AudioBookState();
}

class AudioBookState extends State<AudioBook> {
  Book? book;
  String LanguageStatus = "en";
  static int _nextMediaId = 0;
  late AudioPlayer _player;
  late ConcatenatingAudioSource _playlist;
  int _addedCount = 0;
  String file = '';
  // 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
  @override
  void initState() {
    super.initState();
    book = Get.arguments[0] as Book;
    final localprovider = Get.arguments[1];
    LanguageStatus = Get.arguments[3] as String;
    file = Get.arguments[2] as String;
    // Duration duration = _player.duration!;
    print("book!.audioEn ${book!.audioEn}");
    print('${book!.audioAr}');
    _playlist = ConcatenatingAudioSource(children: [
      ClippingAudioSource(
        start: Duration.zero,
        end: const Duration(minutes: 35), //
        child: file == ""
            ? AudioSource.uri(Uri.parse(
                // ignore: avoid_dynamic_calls
                // localprovider.localelang!.languageCode == 'ar'
                LanguageStatus == 'ar' ? book!.audioAr : book!.audioEn))
            : AudioSource.file(file),
        tag: MediaItem(
          id: '01',
          album: 'Ejaz Audio Book Service',
          // ignore: cast_nullable_to_non_nullable, avoid_dynamic_calls
          title: localprovider.localelang!.languageCode == 'ar'
              ? book!.bk_Name_Ar as String
              : book!.bk_Name as String,
          artist: 'Ejaz',
          displayDescription: localprovider.localelang!.languageCode == 'ar'
              ? '${book!.bk_Introduction_Ar} ${book!.bk_Summary_Ar} ${book!.bk_Characters_Ar}'
              : '${book!.bk_Introduction} ${book!.bk_Summary} ${book!.bk_Characters}',
          artUri: Uri.parse(book!.imagePath),
        ),
      ),
    ]);

    _player = AudioPlayer();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(_playlist);
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void dispose() {
    // _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_redundant_argument_values

    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    bool? textplay = Provider.of<Testplay>(context, listen: true).textplay;

    return Scaffold(
      body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            // A flexible app bar
            SliverAppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: OutlinedButton.icon(
                      onPressed: () {
                        if (LanguageStatus == 'en') {
                          setState(() {
                            LanguageStatus = 'ar';
                          });
                        } else {
                          setState(() {
                            LanguageStatus = 'en';
                          });
                        }
                        setState(() {});

                        //*********** new Initilaze for Audio player **********************//
                        _player.dispose();
                        _playlist = ConcatenatingAudioSource(children: [
                          ClippingAudioSource(
                            start: Duration.zero,
                            end: const Duration(minutes: 35), //
                            child: file == ""
                                ? AudioSource.uri(Uri.parse(
                                    // ignore: avoid_dynamic_calls
                                    // localprovider.localelang!.languageCode == 'ar'
                                    LanguageStatus == 'ar'
                                        ? book!.audioAr
                                        : book!.audioEn))
                                : AudioSource.file(file),
                            tag: MediaItem(
                              id: '01',
                              album: 'Ejaz Audio Book Service',
                              // ignore: cast_nullable_to_non_nullable, avoid_dynamic_calls
                              title: LanguageStatus == 'ar'
                                  ? book!.bk_Name_Ar as String
                                  : book!.bk_Name as String,
                              artist: 'Ejaz',
                              displayDescription: LanguageStatus == 'ar'
                                  ? '${book!.bk_Introduction_Ar} ${book!.bk_Summary_Ar} ${book!.bk_Characters_Ar}'
                                  : '${book!.bk_Introduction} ${book!.bk_Summary} ${book!.bk_Characters}',
                              artUri: Uri.parse(book!.imagePath),
                            ),
                          ),
                        ]);

                        _player = AudioPlayer();
                        _init();

                        //*********** new Initilaze for Audio player **********************//
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          themeProv.isDarkTheme!
                              ? ColorDark.background
                              : Colors.white,
                        ),
                      ),
                      icon: const Icon(Icons.language, size: 30),
                      label: Text('')
                      // Padding(
                      //   padding: LanguageStatus == 'ar'
                      //       ? EdgeInsets.only(top: 5.0)
                      //       : EdgeInsets.only(top: 0.0),
                      //   child: Text(
                      //     LanguageStatus == 'ar' ? "En" : "ع",
                      //     style: LanguageStatus == 'ar'
                      //         ? TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      //         : TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      ),
                ),
              ],
              backgroundColor: theme.colorScheme.background,
              foregroundColor:
                  themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
            ),
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: StreamBuilder<SequenceState?>(
                      stream: _player.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        final metadata = state!.currentSource!.tag as MediaItem;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: OctoImage(
                                  image: CachedNetworkImageProvider(
                                    metadata.artUri.toString(),
                                  ),
                                  fit: BoxFit.contain,
                                  height: 200,
                                ),
                              ),
                            ),

                            // Text(metadata.album!,
                            //     style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                textAlign: TextAlign.center,
                                metadata.title,
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            downloadProgress(),
                          ],
                        );
                      },
                    ),
                  ),
                  ControlButtons(_player, book!),
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: (newPosition) {
                          _player.seek(newPosition);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      StreamBuilder<LoopMode>(
                        stream: _player.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data ?? LoopMode.off;
                          const icons = [
                            Icon(Icons.repeat, color: Colors.grey),
                            Icon(Icons.repeat, color: Colors.orange),
                            Icon(Icons.repeat_one, color: Colors.orange),
                          ];
                          const cycleModes = [
                            LoopMode.off,
                            LoopMode.all,
                            LoopMode.one,
                          ];
                          final index = cycleModes.indexOf(loopMode);
                          return IconButton(
                            icon: icons[index],
                            onPressed: () {
                              _player.setLoopMode(cycleModes[
                                  (cycleModes.indexOf(loopMode) + 1) %
                                      cycleModes.length]);
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: Text(
                          "Playlist ",
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: _player.shuffleModeEnabledStream,
                        builder: (context, snapshot) {
                          final shuffleModeEnabled = snapshot.data ?? false;
                          return IconButton(
                            icon: shuffleModeEnabled
                                ? const Icon(Icons.shuffle,
                                    color: Colors.orange)
                                : const Icon(Icons.shuffle, color: Colors.grey),
                            onPressed: () async {
                              final enable = !shuffleModeEnabled;
                              if (enable) {
                                await _player.shuffle();
                              }
                              await _player.setShuffleModeEnabled(enable);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 240.0,
                    child: StreamBuilder<SequenceState?>(
                      stream: _player.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        final sequence = state?.sequence ?? [];

                        return ReorderableListView(
                          onReorder: (int oldIndex, int newIndex) {
                            if (oldIndex < newIndex) newIndex--;
                            // _playlist.move(oldIndex, newIndex);
                          },
                          children: [
                            for (var i = 0; i < sequence.length; i++)
                              Dismissible(
                                key: ValueKey(sequence[i]),
                                background: Container(
                                  // color: Colors.redAccent,
                                  alignment: Alignment.centerRight,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                                onDismissed: (dismissDirection) {
                                  //  _playlist.removeAt(i);
                                },
                                child: Material(
                                  color: i == state!.currentIndex
                                      ? Colors.transparent
                                      : null,
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: ListView(
                                              reverse: true,
                                              shrinkWrap: true,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0, right: 8),
                                                  child: ListTile(
                                                    title: Center(
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: DefaultTextStyle(
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 30.0,
                                                              // fontFamily: 'Bobbers',
                                                              color: themeProv
                                                                      .isDarkTheme!
                                                                  ? Colors.white
                                                                  : ColorDark
                                                                      .background),
                                                          child: textplay ==
                                                                  true
                                                              ? AnimatedTextKit(
                                                                onFinished:
                                                                    () {},
                                                                animatedTexts: [
                                                                  // ignore: avoid_dynamic_calls
                                                                  TypewriterAnimatedText(
                                                                    cursor: "",
                                                                    textAlign: LanguageStatus == 'ar'
                                                                        ? TextAlign.right
                                                                        : TextAlign.left,
                                                                    // ignore: avoid_dynamic_calls
                                                                    sequence[i]
                                                                        .tag
                                                                        .displayDescription as String,
                                                                    speed:
                                                                        const Duration(milliseconds: 80),
                                                                  ),
                                                                ],
                                                                onTap:
                                                                    () {
                                                                  print(
                                                                      "Tap Event");
                                                                },
                                                              )
                                                              : Container(), //Text(AppLocalizations.of(context)!.textappear,style: TextStyle(fontSize: 20),),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      //  _player.seek(Duration.zero,
                                                      //      index: i);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget downloadProgress() {
    var fileDownloaderProvider =
        Provider.of<FileDownloaderProvider>(context, listen: true);

    return Text(
      downloadStatus(fileDownloaderProvider).toString(),
      style: TextStyle(
          fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
    );
  }

  downloadStatus(FileDownloaderProvider fileDownloaderProvider) {
    var retStatus = "";

    switch (fileDownloaderProvider.downloadStatus) {
      case DownloadStatus.Downloading:
        {
          retStatus = "Download Progress : " +
              fileDownloaderProvider.downloadPercentage.toString() +
              "%";
        }
        break;
      case DownloadStatus.Completed:
        {
          retStatus = "Download Completed";
        }
        break;
      case DownloadStatus.NotStarted:
        {
          retStatus = "";
        }
        break;
      case DownloadStatus.Started:
        {
          retStatus = "Download Started";
        }
        break;
    }

    return retStatus;
  }
}

class ControlButtons extends StatefulWidget {
  final AudioPlayer player;
  final Book book;

  ControlButtons(this.player, this.book, {Key? key}) : super(key: key);

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  bool _isLiked = false;
  List<Book> ListFavAudio = [];
  List<bool> _isChecked = [];
  late Widget currentPage;
  @override
  void initState() {
    super.initState();
    _isChecked = List<bool>.filled(mockBookList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = MediaQuery.of(context).size.height;
    var fileDownloaderProvider =
        Provider.of<FileDownloaderProvider>(context, listen: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () async {
              bool extis = false;
              List<dynamic> ListDownload = [];
              var box = await Hive.openBox('Listbookdownloads1');
              var ListDownload2 = box.get('Listbookdownloads1') != null
                  ? box.get('Listbookdownloads1')
                  : null;
              if (ListDownload2 != null) {
                ListDownload = ListDownload2 as List<dynamic>;
                for (final element in ListDownload) {
                  if (element.bk_ID == widget.book.bk_ID) {
                    extis = true;
                  }
                }
                if (extis == false) {
                  ListDownload.add(widget.book);
                  addBook(books: ListDownload, boxName: 'Listbookdownloads1');
                }
              } else {
                ListDownload.add(widget.book);
                await addBook(
                    books: ListDownload, boxName: 'Listbookdownloads1');
              }

              //download audio file  in local storage
              await fileDownloaderProvider
                  .downloadFile(widget.book.audioEn, "${widget.book.bk_ID}.mp3")
                  .then((onValue) {});
            },
            icon: Icon(Icons.download)),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: widget.player.volumeStream,
              onChanged: widget.player.setVolume,
              value: 0.1,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: widget.player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed:
                widget.player.hasPrevious ? widget.player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: widget.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 64.0,
                  onPressed: () => OnatPaly(true));
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 64.0,
                  onPressed: () => Onatpause(false)); //widget.player.pause);
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => widget.player.seek(Duration.zero,
                    index: widget.player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: widget.player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: widget.player.hasNext ? widget.player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: widget.player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: widget.player.speedStream,
                onChanged: widget.player.setSpeed,
                value: 0.1,
              );
            },
          ),
        ),
        IconButton(
          onPressed: () async {
            // await widget.player.dispose();
            // await widget.player.load();
            // print("player dispose done");
            // setState(() {});
          },

          icon: Icon(_isLiked ? Icons.add_circle_outline : Icons.refresh),
          //color: ColorLight.primary,
        ),
      ],
    );
  }

  Widget section(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 20,
            color: ColorDark.background,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  // ignore: always_declare_return_types, avoid_positional_boolean_parameters, inference_failure_on_function_return_type
  OnatPaly(bool? playing) {
    widget.player.play();
    Provider.of<MyState>(context, listen: false).isPlayingAudio(playing);
    Provider.of<MyState>(context, listen: false).AudioData(widget.player);
    Provider.of<Testplay>(context, listen: false).isTestplay(true);
  }

  // ignore: always_declare_return_types, avoid_positional_boolean_parameters, inference_failure_on_function_return_type
  Onatpause(bool? playing) {
    widget.player.pause();
    Provider.of<MyState>(context, listen: false).isPlayingAudio(playing);
    Provider.of<MyState>(context, listen: false).AudioData(widget.player);
    Provider.of<Testplay>(context, listen: false).isTestplay(false);
  }

  // ignore: always_declare_return_types, inference_failure_on_function_return_type
  OntapList(book) {
    if (_isLiked == true) {
      setState(() {
        ListFavAudio.removeWhere((e) => e.bk_ID == book!.bk_ID);
        _isLiked = false;
      });
      // Provider.of<MyState>(context, listen: false).decrease();
    } else {
      setState(() {
        ListFavAudio.add(book as Book);
        _isLiked = true;
      });
      //  Provider.of<MyState>(context, listen: false).isPlayingAudio();
    }
  }

  Widget buildAudioList(Book book) {
    final localprovider = Provider.of<LocaleProvider>(context, listen: true);
    return InkWell(
      onTap: () => Get.toNamed<dynamic>(Routes.playerList, arguments: book),
      child: Column(
        children: [
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  book.imagePath,
                  fit: BoxFit.cover,
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            title: Text(
              localprovider.localelang!.languageCode == 'en'
                  ? book.bk_Name!
                  : book.bk_Name_Ar!,
              style: const TextStyle(height: 1.3),
            ),
            // subtitle: Text(book.authors!),
          ),
        ],
      ),
    );
  }
}

Future<void> addBook(
    {required String boxName, required List<dynamic> books}) async {
  var box = await Hive.openBox(boxName);
  box.put(boxName, books);

  print("WALLPAPER ADICIONADO NO HIVE!");
}
