import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/local/download/download_database_service.dart';
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
}
