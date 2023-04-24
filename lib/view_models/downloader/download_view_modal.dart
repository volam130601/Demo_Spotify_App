import 'package:flutter/cupertino.dart';

import '../../models/local/track_download.dart';
import '../../repository/local/download_repository.dart';

class DownloadViewModel with ChangeNotifier {
  late List<TrackDownload> _tracksDownload;
  List<TrackDownload> get tracks => _tracksDownload;

  loadTracksDownloaded() {
    DownloadRepository.instance.getAllTrackDownloads().then((value) {
      _tracksDownload = value;
    });
  }

  String getTaskIdByTrackId(int trackId) {
    for(var item in _tracksDownload) {
      if(item.id == trackId) {
        return item.taskId.toString();
      }
    }
    return '';
  }

  bool checkExistTrackId(int trackId) {
    for (var item in _tracksDownload) {
      if (item.id == trackId) {
        return true;
      }
    }
    return false;
  }
}
