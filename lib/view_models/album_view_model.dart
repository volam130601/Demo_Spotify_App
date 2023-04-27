import 'dart:developer';

import 'package:demo_spotify_app/repository/remote/album_repository.dart';
import 'package:flutter/cupertino.dart';

import '../data/response/api_response.dart';
import '../models/album.dart';
import '../models/track.dart';
import '../utils/common_utils.dart';

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

  ///Size in bytes of tracks in Album
  String totalSizeDownload = '';

  setTotalSizeDownload(String totalSize) {
    totalSizeDownload = totalSize;
    notifyListeners();
  }

  Future<void> fetchTotalSizeDownload(int albumId) async {
    await _tracks.getTracksByAlbumId(albumId).then((value) async {
      String totalSize = await CommonUtils.getSizeInBytesOfTrackDownload(
          value.where((element) => element.preview != '').toList());
      return setTotalSizeDownload(totalSize);
    }).onError((error, stackTrace) =>
        log('Error fetch total size download'));
  }
}
