import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:demo_spotify_app/data/local/download/download_service.dart';
import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../models/track.dart';
import '../../../../view_models/downloader/download_view_modal.dart';

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
    if (widget.playlistId != null) {
      Provider.of<TrackPlayViewModel>(context, listen: false)
          .fetchTracksDownloadByPlaylistID(widget.playlistId!, 0, 100);
    }
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    IsolateNameServer.lookupPortByName('downloader_track')
        ?.send([id, status.value, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final value =
                Provider.of<TrackPlayViewModel>(context, listen: false);
            final downloadProvider =
                Provider.of<DownloadViewModel>(context, listen: false);
            final status = await Permission.storage.request();
            if (status.isGranted) {
              List<Track>? tracks = value.tracksDownload.data;
              await DownloadService.instance.downloadFiles(tracks!);
              print('down done 1');
              await downloadProvider.loadTracksDownloaded();
              print('down done 2');
            } else {
              log("Permission denied");
            }
          },
          icon: const Icon(Icons.downloading),
        ),
      ],
    );
  }
}
