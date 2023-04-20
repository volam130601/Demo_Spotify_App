import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class ActionDownloadPlaylist extends StatefulWidget {
  const ActionDownloadPlaylist({Key? key, this.playlistId}) : super(key: key);
  final int? playlistId;

  @override
  State<ActionDownloadPlaylist> createState() => _ActionDownloadPlaylistState();
}

class _ActionDownloadPlaylistState extends State<ActionDownloadPlaylist> {
  final ReceivePort port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_playlist');
    port.listen((data) async {
      final taskId = data[0];
      final status = data[1];
      final progress = data[2];
      if (status == DownloadTaskStatus.complete.value) {
        log('download');
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id,
      DownloadTaskStatus status,
      int progress,
      ) {
    IsolateNameServer.lookupPortByName('downloader_playlist')
        ?.send([id, status.value, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_playlist');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {


    }, icon: const Icon(Icons.downloading));
  }
}
