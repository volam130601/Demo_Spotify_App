import 'package:demo_spotify_app/data/response/api_response.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/repository/remote/album_repository.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:flutter/material.dart';

import '../repository/remote/artist_repository.dart';
import '../repository/remote/track_repository.dart';

class TrackPlayViewModel with ChangeNotifier {
  final _tracks = TrackRepository();
  final _trackDetail = TrackRepository();
  final _tracksPlayControl = TrackRepository();
  final _artists = ArtistRepository();
  final _album = AlbumRepository();

  ApiResponse<Track> trackDetail = ApiResponse.loading();
  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  ApiResponse<List<Track>> tracksPlayControl = ApiResponse.loading();
  ApiResponse<List<Track>> tracksDownload = ApiResponse.loading();

  String _totalDuration = '';

  String get totalDuration => _totalDuration;

  setTotalDuration(String duration) {
    _totalDuration = duration;
    notifyListeners();
  }

  setTrackDetail(ApiResponse<Track> response) {
    trackDetail = response;
    notifyListeners();
  }

  setTrackList(ApiResponse<List<Track>> response) {
    tracks = response;
    notifyListeners();
  }

  setTracksPlayControl(ApiResponse<List<Track>> response) {
    tracksPlayControl = response;
    notifyListeners();
  }

  setTracksDownload(ApiResponse<List<Track>> response) {
    tracksDownload = response;
    notifyListeners();
  }

  Future<void> fetchTracksPlayControl(
      {int albumID = 0,
      int playlistID = 0,
      int artistID = 0,
      int index = 0,
      int limit = 5}) async {
    if (albumID != 0) {
      await _album
          .getTracksByAlbumId(albumID)
          .then((value) => setTracksPlayControl(ApiResponse.completed(value)))
          .onError((error, stackTrace) =>
              setTracksPlayControl(ApiResponse.error(error.toString())));
    } else if (playlistID != 0) {
      await _tracks
          .getTracksByPlaylistID(playlistID, index, 10000)
          .then((value) {
        return setTotalDuration(CommonUtils.instance.convertTotalDuration(value));
      });
      await _tracksPlayControl
          .getTracksByPlaylistID(playlistID, index, limit)
          .then((value) {
        return setTracksPlayControl(ApiResponse.completed(value));
      }).onError((error, stackTrace) =>
              setTracksPlayControl(ApiResponse.error(error.toString())));
    } else if (artistID != 0) {
      await _artists
          .getTrackPopularByArtistID(artistID, index, limit)
          .then((value) => setTracksPlayControl(ApiResponse.completed(value)))
          .onError((error, stackTrace) =>
              setTracksPlayControl(ApiResponse.error(error.toString())));
    }
  }

  Future<void> fetchTracksByID(int albumID) async {
    await _trackDetail
        .getTrackByID(albumID)
        .then((value) => setTrackDetail(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTrackDetail(ApiResponse.error(error.toString())));
  }

  Future<void> fetchTracksDownloadByPlaylistID(
      int playlistID, int index, int limit) async {
    await _tracks
        .getTracksByPlaylistID(playlistID, index, limit)
        .then((value) => setTracksDownload(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTracksDownload(ApiResponse.error(error.toString())));
  }
}
