import 'package:demo_spotify_app/data/local/download/download_database_service.dart';
import 'package:demo_spotify_app/models/local_model/track_download.dart';
import 'package:flutter/cupertino.dart';

class DownloadViewModel with ChangeNotifier {
  late List<TrackDownload> _tracksDownload;

  List<TrackDownload> get tracks => _tracksDownload;

  loadTracksDownloaded() {
    DownloadDBService.instance.getAllTrackDownloads().then((value) {
      _tracksDownload = value;
    });
  }

  String getTaskIdByTrackId(String trackId) {
    for(var item in _tracksDownload) {
      if(item.trackId == trackId) {
        return item.taskId.toString();
      }
    }
    return '';
  }


  bool checkExistTrackId(String trackId) {
    for (var item in _tracksDownload) {
      if (item.trackId == trackId) {
        return true;
      }
    }
    return false;
  }
}
