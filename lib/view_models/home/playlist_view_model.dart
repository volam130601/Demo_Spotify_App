import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/repository/remote/playlist_repository.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';

import '../../data/response/api_response.dart';
import '../../models/track.dart';

class PlaylistViewModel with ChangeNotifier {
  final _tracks = PlaylistRepository();
  final _playlistDetail = PlaylistRepository();

  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  ApiResponse<Playlist> playlistDetail = ApiResponse.loading();
  List<Track> tracksPaging = [];
  bool isLoading = false;
  int playlistId = 0;
  int totalSizeDownload = 0;

  setTracks(ApiResponse<List<Track>> response) {
    tracks = response;
    notifyListeners();
  }

  setTracksPaging(List<Track> response) {
    if (response.isEmpty) {
      isLoading = false;
    }
    for (var element in response) {
      tracksPaging.add(element);
    }
    notifyListeners();
  }

  setPlaylistDetail(ApiResponse<Playlist> response) {
    playlistDetail = response;
    notifyListeners();
  }

  setTotalSizeDownload(int totalSize) {
    totalSizeDownload += totalSize;
    notifyListeners();
  }

  setIsLoading(newValue) {
    isLoading = newValue;
    notifyListeners();
  }

  Future<void> fetchTracksByPlaylistId(
      int playlistId, int index, int limit) async {
    await _tracks.getTracksByPlaylistId(playlistId, index, limit).then((value) {
      List<Track> tracks =
          value.where((element) => element.preview != '').toList();
      setTracksPaging(tracks.take(10).toList());
      return setTracks(ApiResponse.completed(tracks));
    }).onError(
        (error, stackTrace) => setTracks(ApiResponse.error(error.toString())));
  }

  Future<void> fetchTracksPagingByPlaylistId(
      int playlistId, int index, int limit) async {
    List<Track> trackDownload= [];
    await _tracks.getTracksByPlaylistId(playlistId, index, limit).then((value) {
      List<Track> temp = value.where((element) => element.preview != '').toList();
      trackDownload.addAll(temp);
      return setTracksPaging(temp);
    }).onError((error, stackTrace) =>
        ToastCommon.showCustomText(content: error.toString()));
    fetchTotalSizeDownload(trackDownload);
  }

  Future<void> fetchPlaylistById(int currentPlaylistId) async {
    checkPlaylistId(currentPlaylistId);
    await _playlistDetail
        .getPlaylistByID(currentPlaylistId)
        .then((value) => setPlaylistDetail(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setPlaylistDetail(ApiResponse.error(error.toString())));
  }

  Future<void> fetchTotalSizeDownload(List<Track> tracks) async {
    int totalSize = await CommonUtils.getSizeInBytesOfTrackDownload(tracks);
    setTotalSizeDownload(totalSize);
  }

  void checkPlaylistId(int currentPlaylistId) {
    if (playlistId != currentPlaylistId) {
      tracks = ApiResponse.loading();
      playlistDetail = ApiResponse.loading();
      playlistId = currentPlaylistId;
      totalSizeDownload = 0;
      tracksPaging = [];
      isLoading = false;
    }
  }
}
