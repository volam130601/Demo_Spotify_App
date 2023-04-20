import 'package:flutter/cupertino.dart';

import '../../models/track.dart';

class DownloadViewModel with ChangeNotifier {
  late Track _track;

  Track get track => _track;

  setTrack(Track track) {
    _track = track;
    notifyListeners();
  }

}