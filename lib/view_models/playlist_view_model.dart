import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/repository/remote/playlist_repository.dart';
import 'package:flutter/cupertino.dart';

import '../data/response/api_response.dart';
import '../models/track.dart';

class PlaylistViewModel with ChangeNotifier {
  //TODO: Build playlist view model
  final _tracks = PlaylistRepository();
  final _playlistDetail = PlaylistRepository();

  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  ApiResponse<Playlist> playlistDetail = ApiResponse.loading();

  setTracks(ApiResponse<List<Track>> response) {
    tracks = response;
    notifyListeners();
  }

  setPlaylistDetail(ApiResponse<Playlist> response) {
    playlistDetail = response;
    notifyListeners();
  }

  Future<void> fetchTracksByPlaylistId(
      int playlistId, int index, int limit) async {
    await _tracks
        .getTracksByPlaylistId(playlistId, index, limit)
        .then((value) => setTracks(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTracks(ApiResponse.error(error.toString())));
  }

  Future<void> fetchPlaylistById(int playlistId) async {
    await _playlistDetail
        .getPlaylistByID(playlistId)
        .then((value) => setPlaylistDetail(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setPlaylistDetail(ApiResponse.error(error.toString())));
  }
}
