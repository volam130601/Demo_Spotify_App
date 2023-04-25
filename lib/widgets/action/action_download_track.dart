import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../models/playlist.dart';
import '../../../../models/track.dart';
import '../../../../view_models/downloader/download_view_modal.dart';
import '../../models/album.dart';
import '../../repository/local/download_repository.dart';

class ActionDownloadTracks extends StatefulWidget {
  const ActionDownloadTracks({Key? key, this.playlist, this.album, this.tracks})
      : super(key: key);
  final Playlist? playlist;
  final Album? album;
  final List<Track>? tracks;

  @override
  State<ActionDownloadTracks> createState() => _ActionDownloadTracksState();
}

class _ActionDownloadTracksState extends State<ActionDownloadTracks> {
  final ReceivePort port = ReceivePort();

  @override
  void initState() {
    super.initState();
    if (widget.playlist != null) {
      Provider.of<TrackPlayViewModel>(context, listen: false)
          .fetchTracksDownloadByPlaylistID(widget.playlist!.id!, 0, 1000);
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
            final downloadProvider =
                Provider.of<DownloadViewModel>(context, listen: false);
            final value =
                Provider.of<TrackPlayViewModel>(context, listen: false);
            final status = await Permission.storage.request();
            if (status.isGranted) {
              if (widget.playlist != null) {
                print('Multi playlist download');
                List<Track>? tracks = value.tracksDownload.data;
                await DownloadRepository.instance
                    .downloadTracks(tracks!, playlistId: widget.playlist!.id);
                await DownloadRepository.instance
                    .insertPlaylistDownload(widget.playlist!);
              }
              if (widget.album != null) {
                print('Multi album download');
                await DownloadRepository.instance
                    .downloadTracks(widget.tracks!, album: widget.album);
                await DownloadRepository.instance
                    .insertAlbumDownload(widget.album!);
              }
              await downloadProvider.loadTracksDownloaded();
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
