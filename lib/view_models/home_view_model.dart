import 'dart:math';

import 'package:demo_spotify_app/data/response/api_response.dart';
import 'package:flutter/material.dart';

import '../models/album.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../repository/chart_repository.dart';

class HomeViewModel with ChangeNotifier {
  final _chartPlaylist = ChartRepository();
  final _chartAlbum = ChartRepository();
  final _chartTrack = ChartRepository();
  final _chartArtist = ChartRepository();

  ApiResponse<List<Playlist>> chartPlaylists = ApiResponse.loading();
  ApiResponse<List<Album>> chartAlbums = ApiResponse.loading();
  ApiResponse<List<Track>> chartTracks = ApiResponse.loading();
  ApiResponse<List<Artist>> chartArtists = ApiResponse.loading();

  setChartPlaylists(ApiResponse<List<Playlist>> response) {
    chartPlaylists = response;
    notifyListeners();
  }

  setChartAlbums(ApiResponse<List<Album>> response) {
    chartAlbums = response;
    notifyListeners();
  }

  setChartTracks(ApiResponse<List<Track>> response) {
    chartTracks = response;
    notifyListeners();
  }

  setChartArtists(ApiResponse<List<Artist>> response) {
    chartArtists = response;
    notifyListeners();
  }

  Future<void> fetchChartPlaylistsApi() async {
    await _chartPlaylist
        .getChartPlaylists()
        .then((value) => setChartPlaylists(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setChartPlaylists(ApiResponse.error(error.toString())));
  }

  Future<void> fetchChartAlbumsApi() async {
    await _chartAlbum
        .getChartAlbums()
        .then((value) => setChartAlbums(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setChartAlbums(ApiResponse.error(error.toString())));
  }

  Future<void> fetchChartTracksApi() async {
    await _chartTrack
        .getChartTracks()
        .then((value) => setChartTracks(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setChartTracks(ApiResponse.error(error.toString())));
  }

  Future<void> fetchChartArtistsApi() async {
    await _chartArtist
        .getChartArtists()
        .then((value) => setChartArtists(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setChartArtists(ApiResponse.error(error.toString())));
  }


  String randomSearchKey() {
    String searchKey = '';
    Random random = Random();
    for (int i = 0; i < 3; i++) {
      searchKey += String.fromCharCode(random.nextInt(26) + 65);
    }
    return searchKey;
  }
}
