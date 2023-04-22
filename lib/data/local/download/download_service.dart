import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/track.dart';
import 'download_database_service.dart';

class DownloadService {
  DownloadService._privateConstructor();

  static final DownloadService instance = DownloadService._privateConstructor();

  Future<void> removeAll() async {
    List<DownloadTask>? tasks = await FlutterDownloader.loadTasks();
    for (int i = 0; i < tasks!.length; i++) {
      FlutterDownloader.remove(taskId: tasks[i].taskId);
      DownloadDBService.instance.deleteAll();
    }
  }

  Future<void> downloadFiles(List<Track> tracks) async {
    final externalDir = await getExternalStorageDirectory();
    for (int index = 0; index < tracks.length; index++) {
      final isBool = await DownloadDBService.instance
          .trackDownloadExists(tracks[index].id.toString());
      if (!isBool) {
        await FlutterDownloader.enqueue(
          url: '${tracks[index].preview}',
          savedDir: externalDir!.path,
          fileName: 'track-${tracks[index].id}.mp3',
          showNotification: false,
          openFileFromNotification: false,
        );
      } else {
        print('Track ${tracks[index].id} downloaded');
      }
    }
  }
}
