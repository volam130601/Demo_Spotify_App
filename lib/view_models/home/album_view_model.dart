import 'package:demo_spotify_app/repository/remote/album_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../data/response/api_response.dart';
import '../../models/album.dart';
import '../../models/track.dart';
import '../../utils/common_utils.dart';

class AlbumViewModel with ChangeNotifier {
  final _tracks = AlbumRepository();
  final _albumDetail = AlbumRepository();

  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  ApiResponse<Album> albumDetail = ApiResponse.loading();
  int albumId = 0;

  setTracks(ApiResponse<List<Track>> response) {
    tracks = response;
    notifyListeners();
  }

  setAlbumDetail(ApiResponse<Album> response) {
    albumDetail = response;
    notifyListeners();
  }

  Future<void> fetchTracksByAlbumId(int albumID) async {
    List<Track> trackDownload = [];
    await _tracks.getTracksByAlbumId(albumID).then((value) {
      List<Track> temp =
          value.where((element) => element.preview != '').toList();
      trackDownload.addAll(temp);
      return setTracks(ApiResponse.completed(temp));
    }).onError(
        (error, stackTrace) => setTracks(ApiResponse.error(error.toString())));
    fetchTotalSizeDownload(trackDownload);
  }

  Future<void> fetchAlbumById(int albumId) async {
    checkAlbumId(albumId);
    await _albumDetail
        .getAlbumById(albumId)
        .then((value) => setAlbumDetail(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setAlbumDetail(ApiResponse.error(error.toString())));
  }

  ///Size in bytes of tracks in Album
  int totalSizeDownload = 0;

  setTotalSizeDownload(int totalSize) {
    totalSizeDownload += totalSize;
    notifyListeners();
  }

  Future<void> fetchTotalSizeDownload(List<Track> tracks) async {
    int totalSize = await CommonUtils.getSizeInBytesOfTrackDownload(tracks);
    setTotalSizeDownload(totalSize);
  }

  void checkAlbumId(int currentAlbumId) {
    if (albumId != currentAlbumId) {
      tracks = ApiResponse.loading();
      albumDetail = ApiResponse.loading();
      albumId = currentAlbumId;
      totalSizeDownload = 0;
    }
  }
}
