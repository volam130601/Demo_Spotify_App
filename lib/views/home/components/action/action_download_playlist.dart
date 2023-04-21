import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:demo_spotify_app/models/local_model/track_download.dart';
import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../data/local/download_database_service.dart';
import '../../../../models/track.dart';
import '../../../../repository/track_repository.dart';

class ActionDownloadPlaylist extends StatefulWidget {
  const ActionDownloadPlaylist({Key? key, this.playlistId}) : super(key: key);
  final int? playlistId;

  @override
  State<ActionDownloadPlaylist> createState() => _ActionDownloadPlaylistState();
}

class _ActionDownloadPlaylistState extends State<ActionDownloadPlaylist> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.playlistId != null) {
      Provider.of<TrackPlayViewModel>(context, listen: false)
          .fetchTracksDownloadByPlaylistID(widget.playlistId!, 0, 10);
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
              List<Track>? tracks =
                  Provider.of<TrackPlayViewModel>(context, listen: false)
                      .tracksDownload
                      .data;
              await downloadFiles(tracks!);
              print('download all done');
            },
            icon: const Icon(Icons.downloading)),
        IconButton(
            onPressed: () async {
              await addTrackToDB();
            },
            icon: Icon(Icons.add_box_outlined)),
        IconButton(
            onPressed: () async {
              await removeAll();
              print('remove all');
              // await DownloadDBService.instance.deleteAll();
            },
            icon: Icon(Icons.restore_from_trash))
      ],
    );
  }

  Future<void> downloadFiles(List<Track> tracks)  async {
    final externalDir = await getExternalStorageDirectory();
    for (int i = 0; i < tracks.length; i++) {
      String fileName = 'playlist-${widget.playlistId}-${tracks[i].id}.mp3';
      final taskId = FlutterDownloader.enqueue(
        url: '${tracks[i].preview}',
        savedDir: externalDir!.path,
        fileName: fileName,
        showNotification: false,
        openFileFromNotification: false,
      );
    }
  }

  Future<void> addTrackToDB() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    for (int i = 0; i < tasks!.length; i++) {
      if (tasks[i].status == DownloadTaskStatus.complete) {
        log('${tasks[i].filename}');
        final externalDir = await getExternalStorageDirectory();
        final trackRepository = TrackRepository();
        String str = '${tasks[i].filename}';
        int lastIndexOfDash = str.lastIndexOf('-');
        String trackID = str.substring(lastIndexOfDash + 1, str.length - 4);
        Track? track = await trackRepository.getTrackByID(int.parse(trackID));
        await DownloadDBService.instance.newTrackDownload(
          TrackDownload(
              trackId: track.id.toString(),
              taskId: tasks[i].taskId,
              title: track.title,
              artistName: track.artist!.name,
              artistPictureSmall: track.artist!.pictureSmall,
              coverSmall: track.album!.coverSmall,
              coverXl: track.album!.coverXl,
              preview: '${externalDir!.path}/${tasks[i].filename}',
              type: 'track_local'),
        );
      }
    }
  }

  Future<void> removeAll() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    for (int i = 0; i < tasks!.length; i++) {
      FlutterDownloader.remove(taskId: tasks[i].taskId);
      DownloadDBService.instance
          .deleteAll();
    }
  }

  String getTrackId(String str) {
    int lastIndexOfDash = str.lastIndexOf('-'); // Find the index of the last dash
    return str.substring(lastIndexOfDash + 1, str.length - 4); // Extract the substring between the last dash and ".mp3"
  }

}
