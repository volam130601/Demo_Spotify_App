import 'package:demo_spotify_app/data/response/api_response.dart';
import 'package:demo_spotify_app/models/album.dart';
import 'package:demo_spotify_app/models/artist.dart';
import 'package:demo_spotify_app/models/genre/genre_search.dart';
import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/repository/genre_repository.dart';
import 'package:demo_spotify_app/repository/search_repository.dart';
import 'package:flutter/material.dart';

import '../models/genre/genre.dart';
import '../models/track.dart';

class SearchViewModel with ChangeNotifier {
  final _tracks = SearchRepository();
  final _albums = SearchRepository();
  final _artists = SearchRepository();
  final _playlists = SearchRepository();

  final _genres = GenreRepository();

  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  ApiResponse<List<Album>> albums = ApiResponse.loading();
  ApiResponse<List<Artist>> artists = ApiResponse.loading();
  ApiResponse<List<Playlist>> playlists = ApiResponse.loading();

  ApiResponse<List<Genre>> genres = ApiResponse.loading();
  ApiResponse<List<GenreSearch>> genreSearches = ApiResponse.loading();

  setTracks(ApiResponse<List<Track>> response) {
    tracks = response;
    notifyListeners();
  }

  setAlbums(ApiResponse<List<Album>> response) {
    albums = response;
    notifyListeners();
  }

  setArtists(ApiResponse<List<Artist>> response) {
    artists = response;
    notifyListeners();
  }

  setPlaylists(ApiResponse<List<Playlist>> response) {
    playlists = response;
    notifyListeners();
  }

  setGenres(ApiResponse<List<Genre>> response) {
    genres = response;
    notifyListeners();
  }

  setGenreSearches(ApiResponse<List<GenreSearch>> response) {
    genreSearches = response;
    notifyListeners();
  }

  Future<void> fetchTracksApi(String searchKey, int index, int limit) async {
    await _tracks
        .getSearchTracks(searchKey, index, limit)
        .then((value) => setTracks(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTracks(ApiResponse.error(error.toString())));
  }

  Future<void> fetchAlbumsApi(String searchKey, int index, int limit) async {
    await _albums
        .getSearchAlbums(searchKey, index, limit)
        .then((value) => setAlbums(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setAlbums(ApiResponse.error(error.toString())));
  }

  Future<void> fetchArtistsApi(String searchKey, int index, int limit) async {
    await _artists
        .getSearchArtists(searchKey, index, limit)
        .then((value) => setArtists(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setArtists(ApiResponse.error(error.toString())));
  }

  Future<void> fetchPlaylistsApi(String searchKey, int index, int limit) async {
    await _playlists
        .getSearchPlaylists(searchKey, index, limit)
        .then((value) => setPlaylists(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setPlaylists(ApiResponse.error(error.toString())));
  }

  Future<void> fetchGenreSearchesApi() async {
    await _genres
        .getGenreSearches()
        .then((value) => setGenreSearches(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
        setGenreSearches(ApiResponse.error(error.toString())));
  }

  Future<void> fetchArtistsByGenreIdApi(String genreId) async {
    await _genres
        .getArtistsByGenreId(genreId)
        .then((value) => setArtists(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
        setArtists(ApiResponse.error(error.toString())));
  }

  Future<void> fetchGenreChildByGenreIdApi(String genreId) async {
    await _genres
        .getGenreChildList(genreId)
        .then((value) => setGenres(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
        setGenres(ApiResponse.error(error.toString())));
  }

  Future<void> fetchTrackTopsByGenreIdApi(String genreId, int index, int limit) async {
    await _genres
        .getTrackTopsByGenreID(genreId, index ,limit)
        .then((value) => setTracks(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
        setTracks(ApiResponse.error(error.toString())));
  }
}
