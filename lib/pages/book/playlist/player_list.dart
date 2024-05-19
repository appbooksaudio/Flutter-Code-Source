// This example demonstrates how to play a playlist with a mix of URI and asset
// audio sources, and the ability to add/remove/reorder playlist items.
//
// To run:
//
// flutter run -t lib/example_playlist.dart

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:ejazapp/data/models/playlist.dart';
import 'package:ejazapp/helpers/colors.dart';
import 'package:ejazapp/pages/book/audio_book/common.dart';
import 'package:ejazapp/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as prefix;
import 'package:get/get_core/get_core.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<Player> with WidgetsBindingObserver {
  late AudioPlayer _player1;
  List audioList = [];

  List<PlayList> CurrentPlayList = [];
  var _playlist = ConcatenatingAudioSource(children: []);
  int _addedCount = 0;
  int numb = 0;
  int count = 0;
  List<AudioSource> z = [];
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    CurrentPlayList = Get.arguments as List<PlayList>;

    _playlist = ConcatenatingAudioSource(
      children: [
        // Remove this audio source from the Windows and Linux version because it's not supported yet
        if (kIsWeb ||
            ![TargetPlatform.windows, TargetPlatform.linux]
                .contains(defaultTargetPlatform))
          for (var i = 0; i < CurrentPlayList[0].pl_audio!.length; i++)
            //  for (var numb = 0; numb < audioList[i].length; numb++)
            ClippingAudioSource(
              start: const Duration(seconds: 60),
              end: const Duration(minutes: 35), //
              child: AudioSource.uri(
                Uri.parse(CurrentPlayList[0].pl_audio![i].ad_source!),
              ),
              tag: MediaItem(
                album: 'Ejaz audio book',
                title: CurrentPlayList[0].pl_audio![i].ad_Name,
                id: CurrentPlayList[0].pl_audio![i].ad_ID,
                artUri: Uri.parse(CurrentPlayList[0].pl_audio![i].imagePath),
              ),
            ),
      ],
    );
    super.initState();

    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _player1 = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      ),
    );
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player1.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
    try {
      // Preloading audio is not currently supported on Linux.
      await _player1.setAudioSource(
        _playlist,
        preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux,
      );
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
    // Show a snackbar whenever reaching the end of an item in the playlist.
    _player1.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });
    _player1.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _showItemFinished(_player1.currentIndex);
      }
    });
  }

  void _showItemFinished(int? index) {
    if (index == null) return;
    final sequence = _player1.sequence;
    if (sequence == null) return;
    final source = sequence[index];
    final metadata = source.tag as MediaItem;
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Finished playing ${metadata.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player1.dispose();
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.paused) {
  //     // Release the player's resources when not in use. We use "stop" so that
  //     // if the app resumes later, it will still remember what position to
  //     // resume from.
  //     _player1.stop();
  //   }
  // }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player1.positionStream,
        _player1.bufferedPositionStream,
        _player1.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // A flexible app bar
          SliverAppBar(
            backgroundColor: theme.colorScheme.background,
            foregroundColor: themeProv.isDarkTheme! ? Colors.blue : Colors.blue,
          ),
          SliverFillRemaining(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: _player1.sequenceStateStream,
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    metadata.artUri.toString(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            metadata.title,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          // Text(metadata.title),
                        ],
                      );
                    },
                  ),
                ),
                ControlButtons(_player1),
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
                        _player1.seek(newPosition);
                      },
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    StreamBuilder<LoopMode>(
                      stream: _player1.loopModeStream,
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
                            _player1.setLoopMode(
                              cycleModes[(cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length],
                            );
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Playlist",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    StreamBuilder<bool>(
                      stream: _player1.shuffleModeEnabledStream,
                      builder: (context, snapshot) {
                        final shuffleModeEnabled = snapshot.data ?? false;
                        return IconButton(
                          icon: shuffleModeEnabled
                              ? const Icon(Icons.shuffle, color: Colors.orange)
                              : const Icon(Icons.shuffle, color: Colors.grey),
                          onPressed: () async {
                            final enable = !shuffleModeEnabled;
                            if (enable) {
                              await _player1.shuffle();
                            }
                            await _player1.setShuffleModeEnabled(enable);
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 240.0,
                  child: StreamBuilder<SequenceState?>(
                    stream: _player1.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      return ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) newIndex--;
                          _playlist.move(oldIndex, newIndex);
                        },
                        children: [
                          for (var i = 0; i < sequence.length; i++)
                            Dismissible(
                              key: ValueKey(sequence[i]),
                              background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerRight,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child:
                                      Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                              onDismissed: (dismissDirection) {
                                _playlist.removeAt(i);
                              },
                              child: Material(
                                color: i == state!.currentIndex
                                    ? Colors.greenAccent
                                    : null,
                                child: ListTile(
                                  tileColor: themeProv.isDarkTheme!
                                      ? ColorDark.background
                                      : Colors.white,
                                  title: Text(
                                    sequence[i].tag.title as String,
                                    style: TextStyle(
                                      color: themeProv.isDarkTheme!
                                          ? Colors.white
                                          : ColorDark.background,
                                    ),
                                  ),
                                  onTap: () {
                                    _player1.seek(Duration.zero, index: i);
                                  },
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
        ],
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
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
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(
                  Duration.zero,
                  index: player.effectiveIndices!.first,
                ),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text(
              "${snapshot.data?.toStringAsFixed(1)}x",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
  });
}
