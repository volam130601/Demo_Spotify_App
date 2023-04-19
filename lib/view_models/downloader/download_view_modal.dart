import 'package:flutter/cupertino.dart';

class DownloadViewModel with ChangeNotifier {
  late String _trackId;

  String get trackId => _trackId;

  setIsLoading(String trackId) {
    _trackId = trackId;
    notifyListeners();
  }
}