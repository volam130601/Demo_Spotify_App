import 'package:demo_spotify_app/data/response/api_response.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:flutter/material.dart';

import '../repository/artist_repository.dart';
import '../repository/track_repository.dart';

class TrackPlayViewModel with ChangeNotifier {
  final _tracks = TrackRepository();
  final _trackDetail = TrackRepository();
  final _tracksPlayControl = TrackRepository();
  final _artists = ArtistRepository();

  ApiResponse<Track> trackDetail = ApiResponse.loading();
  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  ApiResponse<List<Track>> tracksPlayControl = ApiResponse.loading();

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

  Future<void> fetchTracksPlayControl(
      {int albumID = 0,
      int playlistID = 0,
      int artistID = 0,
      int index = 0,
      int limit = 5}) async {
    if (albumID != 0) {
      await _tracksPlayControl
          .getChildTracksByAlbumID(albumID)
          .then((value) => setTracksPlayControl(ApiResponse.completed(value)))
          .onError((error, stackTrace) =>
              setTracksPlayControl(ApiResponse.error(error.toString())));
    } else if (playlistID != 0) {
      await _tracksPlayControl
          .getTracksByPlaylistID(playlistID, index, limit)
          .then((value) => setTracksPlayControl(ApiResponse.completed(value)))
          .onError((error, stackTrace) =>
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

  Future<void> fetchTracksByAlbumID(int albumID, int index, int limit) async {
    await _tracks
        .getChildTracksByAlbumID(albumID)
        .then((value) => setTrackList(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTrackList(ApiResponse.error(error.toString())));
  }

  Future<void> fetchTracksByPlaylistID(
      int playlistID, int index, int limit) async {
    await _tracks
        .getTracksByPlaylistID(playlistID, index, limit)
        .then((value) => setTrackList(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTrackList(ApiResponse.error(error.toString())));
  }
}
