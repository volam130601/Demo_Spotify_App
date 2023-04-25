import 'package:demo_spotify_app/repository/remote/album_repository.dart';
import 'package:flutter/cupertino.dart';

import '../data/response/api_response.dart';
import '../models/album.dart';
import '../models/track.dart';

class AlbumViewModel with ChangeNotifier {
  final _tracks = AlbumRepository();
  final _albumDetail = AlbumRepository();

  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  ApiResponse<Album> albumDetail = ApiResponse.loading();

  setTracks(ApiResponse<List<Track>> response) {
    tracks = response;
    notifyListeners();
  }

  setAlbumDetail(ApiResponse<Album> response) {
    albumDetail = response;
    notifyListeners();
  }

  Future<void> fetchTracksByAlbumId(int albumID) async {
    await _tracks
        .getTracksByAlbumId(albumID)
        .then((value) => setTracks(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTracks(ApiResponse.error(error.toString())));
  }

  Future<void> fetchAlbumById(int albumID) async {
    await _albumDetail
        .getAlbumById(albumID)
        .then((value) => setAlbumDetail(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setAlbumDetail(ApiResponse.error(error.toString())));
  }
}
