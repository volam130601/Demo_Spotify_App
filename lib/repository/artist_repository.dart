import 'package:demo_spotify_app/data/network/network_api_services.dart';
import 'package:demo_spotify_app/models/album.dart';

import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../utils/app_url.dart';

class ArtistRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Artist> getArtistByID(int artistID) async {
    var url = Uri.https(AppUrl.baseURL, '/artist/$artistID');
    final dynamic response = await _apiServices.getGetApiResponse(url);
    return Artist.fromJson(response);
  }

  Future<List<Artist>> getArtistRelatedByArtistID(
      int artistID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/artist/$artistID/related', {
      'index': '$index',
      'limit': '$limit',
    });
    final response = await _apiServices.getGetApiResponse(url);
    if(response.containsKey('error')) {
      return <Artist>[];
    }
    final List<dynamic> items = response['data'];
    return items.map((item) => Artist.fromJson(item)).toList();
  }

  Future<List<Track>> getTrackPopularByArtistID(
      int artistID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/artist/$artistID/top', {
      'index': '$index',
      'limit': '$limit',
    });
    final response = await _apiServices.getGetApiResponse(url);
    if(response.containsKey('error')) {
      return <Track>[];
    }
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }

  Future<List<Track>> getTrackRadiosByArtistID(
      int artistID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/artist/$artistID/radio', {
      'index': '$index',
      'limit': '$limit',
    });
    final response = await _apiServices.getGetApiResponse(url);
    if(response.containsKey('error')) {
      return <Track>[];
    }
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }

  Future<List<Album>> getAlbumPopularByArtistID(
      int artistID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/artist/$artistID/albums', {
      'index': '$index',
      'limit': '$limit',
    });
    final response = await _apiServices.getGetApiResponse(url);
    if(response.containsKey('error')) {
      return <Album>[];
    }
    final List<dynamic> items = response['data'];
    return items.map((item) => Album.fromJson(item)).toList();
  }

  Future<List<Playlist>> getPlaylistByArtistID(
      int artistID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/artist/$artistID/playlists', {
      'index': '$index',
      'limit': '$limit',
    });
    final Map<String, dynamic> response = await _apiServices.getGetApiResponse(url);
    if(response.containsKey('error')) {
      return <Playlist>[];
    }
    final List<dynamic> items = response['data'];
    return items.map((item) => Playlist.fromJson(item)).toList();
  }
}
