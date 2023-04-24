import 'package:demo_spotify_app/data/response/api_response.dart';
import 'package:demo_spotify_app/models/album.dart';
import 'package:demo_spotify_app/models/playlist.dart';
import 'package:flutter/material.dart';

import '../models/artist.dart';
import '../models/track.dart';
import '../repository/remote/artist_repository.dart';

class ArtistViewModel with ChangeNotifier {
  final _artist = ArtistRepository();
  final _artistList = ArtistRepository();
  final _trackList = ArtistRepository();
  final _radioList = ArtistRepository();
  final _albumList = ArtistRepository();
  final _playlistList = ArtistRepository();

  ApiResponse<Artist> artist = ApiResponse.loading();
  ApiResponse<List<Artist>> artistList = ApiResponse.loading();
  ApiResponse<List<Track>> trackList = ApiResponse.loading();
  ApiResponse<List<Track>> radioList = ApiResponse.loading();
  ApiResponse<List<Album>> albumList = ApiResponse.loading();
  ApiResponse<List<Playlist>> playlistList = ApiResponse.loading();

  setArtist(ApiResponse<Artist> response) {
    artist = response;
    notifyListeners();
  }

  setArtistList(ApiResponse<List<Artist>> response) {
    artistList = response;
    notifyListeners();
  }

  setTrackList(ApiResponse<List<Track>> response) {
    trackList = response;
    notifyListeners();
  }

  setRadioList(ApiResponse<List<Track>> response) {
    radioList = response;
    notifyListeners();
  }

  setAlbumList(ApiResponse<List<Album>> response) async {
    albumList = response;
    notifyListeners();
  }

  setPlaylistList(ApiResponse<List<Playlist>> response) {
    playlistList = response;
    notifyListeners();
  }

  Future<void> fetchArtistApi(int artistID) async {
    await _artist
        .getArtistByID(artistID)
        .then((value) => setArtist(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setArtist(ApiResponse.error(error.toString())));
  }

  Future<void> fetchArtistRelatedByArtistID(
      int artistID, int index, int limit) async {
    await _artistList
        .getArtistRelatedByArtistID(artistID, index, limit)
        .then((value) => setArtistList(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setArtistList(ApiResponse.error(error.toString())));
  }

  Future<void> fetchTrackPopularByArtistID(
      int artistID, int index, int limit) async {
    await _trackList
        .getTrackPopularByArtistID(artistID, index, limit)
        .then((value) => setTrackList(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTrackList(ApiResponse.error(error.toString())));
  }

  Future<void> fetchTrackRadiosByArtistID(
      int artistID, int index, int limit) async {
    await _radioList
        .getTrackRadiosByArtistID(artistID, index, limit)
        .then((value) => setRadioList(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setRadioList(ApiResponse.error(error.toString())));
  }

  Future<void> fetchAlbumPopularByArtistID(
      int artistID, int index, int limit) async {
    await _albumList
        .getAlbumPopularByArtistID(artistID, index, limit)
        .then((value) => setAlbumList(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setAlbumList(ApiResponse.error(error.toString())));
  }

  Future<void> fetchPlaylistByArtistID(
      int artistID, int index, int limit) async {
    await _playlistList
        .getPlaylistByArtistID(artistID, index, limit)
        .then((value) => setPlaylistList(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setPlaylistList(ApiResponse.error(error.toString())));
  }
}
