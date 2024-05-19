import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:ejazapp/data/models/audio.dart';
import 'package:ejazapp/data/models/book.dart';
import 'package:ejazapp/data/models/favorite.dart';
import 'package:ejazapp/data/models/playlist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

 AudioHandler? audioHandler;
Box? mybox;

class MyServices extends GetxService {
  late SharedPreferences prefs;

  Future<MyServices> init() async {
    await Firebase.initializeApp();
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', false);
    return this;
  }

  Future<Box> openHiveBox(String boxname) async {
    Hive
      ..registerAdapter(
        BookAdapter(),
      )
      ..registerAdapter(PlayListAdapter())
      ..registerAdapter(AudioAdapter())
      ..registerAdapter(
        FavoriteAdapter(),
      );
    if (!Hive.isBoxOpen(boxname)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }
    return await Hive.openBox(boxname);
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  var notification = message.notification;
  var android = message.notification?.android;
  if (notification != null) {
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
  }
}

// ignore: always_declare_return_types, inference_failure_on_function_return_type, type_annotate_public_apis
init() async {
  // await JustAudioBackground.init(
  //   androidNotificationChannelId: 'com.ejazapphbku.ejazapp.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ejazapphbku.ejazapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      //notificationColor: ,
    ),
  );

}
 class MyAudioHandler extends BaseAudioHandler with SeekHandler {
      final _player = AudioPlayer();
      // In this simple example, we handle only 4 actions: play, pause, seek and
      // stop. Any button press from the Flutter UI, notification, lock screen or
      // headset will be routed through to these 4 methods so that you can handle
      // your audio playback logic in one place.
     AudioPlayerHandler() {
        // what state to display, here we set up our audio handler to broadcast all
        // playback state changes as they happen via playbackState...
        _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
      }
      @override
      Future<void> play() => _player.play();
    
      @override
      Future<void> pause() => _player.pause();
    
      @override
      Future<void> seek(Duration position) => _player.seek(position);
    
      @override
      Future<void> stop() => _player.stop();
    
      /// Transform a just_audio event into an audio_service state.
      ///
      /// This method is used from the constructor. Every event received from the
      /// just_audio player will be transformed into an audio_service state so that
      /// it can be broadcast to audio_service clients.
      PlaybackState _transformEvent(PlaybackEvent event) {
        return PlaybackState(
          controls: [
            MediaControl.rewind,
            if (_player.playing) MediaControl.pause else MediaControl.play,
            MediaControl.stop,
            MediaControl.fastForward,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },
          androidCompactActionIndices: const [0, 1, 3],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          playing: _player.playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: event.currentIndex,
        );
      }
}




Future<void> initPlatformState() async {
  await Purchases.setDebugLogsEnabled(true);

  late PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration('goog_pwRBzMLHiUhliWkpkHjvkwkdSKj');
  } else if (Platform.isIOS) {
    configuration = PurchasesConfiguration('appl_YGGMuKFvmyquizlDJrLSHwGgLio');
  }
  await Purchases.configure(configuration);
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());

  // ignore: inference_failure_on_function_invocation
//  audioHandler = await MyServices().audioinit();
  init();

  mybox = await MyServices().openHiveBox('data');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initPlatformState();
}
