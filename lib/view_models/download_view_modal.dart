import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../models/local/track_download.dart';
import '../repository/local/download_repository.dart';

class DownloadViewModel with ChangeNotifier {
  final List<TrackDownload> _tracksDownloads = [];

  List<TrackDownload> get trackDownloads => _tracksDownloads;

  setTrackDownload(List<TrackDownload> trackDownloads) {
    _tracksDownloads.addAll(trackDownloads);
    notifyListeners();
  }

  addTrackDownload(newValue) {
    _tracksDownloads.add(newValue);
    notifyListeners();
  }

  removeTrackDownload(int trackId) {
    _tracksDownloads.removeWhere((item) => item.id == trackId);
    notifyListeners();
  }

  clearTrackDownloads() {
    _tracksDownloads.clear();
    notifyListeners();
  }

  void loadTrackDownload() async {
    await DownloadRepository.instance
        .getAllTrackDownloads()
        .then((value) => setTrackDownload(value))
        .onError((error, stackTrace) => log('Get all track download error!'));
  }
}
