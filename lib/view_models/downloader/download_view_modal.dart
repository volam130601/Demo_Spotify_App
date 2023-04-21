import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/local/download_database_service.dart';
import '../../models/local_model/track_download.dart';
import '../../models/track.dart';
import '../../repository/track_repository.dart';

class DownloadViewModel with ChangeNotifier {
  late List<Track> _tracksDownload;

  List<Track> get tracks => _tracksDownload;

  setTrack(List<Track> tracks) {
    _tracksDownload = tracks;
    notifyListeners();
  }

  /*Future<void> downloadFiles(List<Track> tracks)  async {
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
      // final trackRepository = TrackRepository();
      // Track? track = await trackRepository.getTrackByID(tracks[i].id!);
    }
  }*/

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
}
