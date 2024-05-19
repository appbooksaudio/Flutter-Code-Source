import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum DownloadStatus { NotStarted, Started, Downloading, Completed }

class FileDownloaderProvider with ChangeNotifier {
  StreamSubscription? _downloadSubscription;
  DownloadStatus _downloadStatus = DownloadStatus.NotStarted;
  int _downloadPercentage = 0;
  String _downloadedFile = "";

  int get downloadPercentage => _downloadPercentage;
  DownloadStatus get downloadStatus => _downloadStatus;
  String get downloadedFile => _downloadedFile;

  Future downloadFile(String url, String fileid) async {
    bool _permissionReady = await _checkPermission();
    final Completer<void> completer = Completer<void>();

    if (!_permissionReady) {
      _checkPermission().then((hasGranted) {
        _permissionReady = hasGranted;
      });
    } else {
      final httpClient = http.Client();
      final request = new http.Request('GET', Uri.parse(url));
      final response = httpClient.send(request);

      final dir = Platform.isAndroid
          ? '/sdcard/download'
          : (await getApplicationDocumentsDirectory()).path;

      List<List<int>> chunks = [];
      int downloaded = 0;

      updateDownloadStatus(DownloadStatus.Started);

      _downloadSubscription =
          response.asStream().listen((http.StreamedResponse r) {
        updateDownloadStatus(DownloadStatus.Downloading);
        r.stream.listen((List<int> chunk) async {
          // Display percentage of completion
          print('downloadPercentage onListen : $_downloadPercentage');

          chunks.add(chunk);
          downloaded += chunk.length;
          _downloadPercentage =
              (downloaded / r.contentLength!.toInt() * 100).round();
          notifyListeners();
        }, onDone: () async {
          // Display percentage of completion
          _downloadPercentage =
              (downloaded / r.contentLength!.toInt() * 100).round();
          notifyListeners();
          print('downloadPercentage onDone: $_downloadPercentage');

          // Save the file

          File file = new File('$dir/$fileid');

          _downloadedFile = '$dir/$fileid';
          print(_downloadedFile);

          final Uint8List bytes = Uint8List(r.contentLength!.toInt());
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }
          await file.writeAsBytes(bytes);

          updateDownloadStatus(DownloadStatus.Completed);
          _downloadSubscription?.cancel();
          _downloadPercentage = 0;

          notifyListeners();
          print('DownloadFile: Completed');
          completer.complete();

          return;
        });
      });
    }

    await completer.future;
  }

  void updateDownloadStatus(DownloadStatus status) {
    _downloadStatus = status;
    print('updateDownloadStatus: $status');
    notifyListeners();
  }

  Future<bool> _checkPermission() async {
    final permission = Permission.storage;
    final status = await permission.status;

    /// here it is coming as PermissionStatus.granted
    if (status != PermissionStatus.granted) {
      await permission.request();
      if (await permission.status.isGranted) {
        ///perform other stuff to download file
        return true;
      } else {
        await permission.request();
      }
      debugPrint('>>> ${await permission.status}');
    }

    return true;
  }
}
