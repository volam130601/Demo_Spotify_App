import 'package:demo_spotify_app/data/network/network_api_services.dart';
import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/utils/app_url.dart';

import '../../models/album.dart';
import '../../models/artist.dart';
import '../../models/track.dart';

class ChartRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<List<Album>> getChartAlbums() async {
    var url = Uri.https(AppUrl.baseURL, '/chart/0/albums', {
      'index' : '0',
      'limit' : '10',
    });
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Album.fromJson(item)).toList();
  }

/*
  Future<List<Album>> getChartAlbums(String searchKey) async {
    var url = Uri.https(AppUrl.baseURL, '/search/album',
        {'q': searchKey, 'limit': '15', 'index': '0'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Album.fromJson(item)).toList();
  }
*/

  Future<List<Track>> getChartTracks() async {
    var url = Uri.https(AppUrl.baseURL, '/chart/0/tracks');
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }

  Future<List<Artist>> getChartArtists() async {
    var url = Uri.https(AppUrl.baseURL, '/chart/0/artists', {'index': '5'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Artist.fromJson(item)).toList();
  }

  Future<List<Playlist>> getChartPlaylists() async {
    var url = Uri.https(AppUrl.baseURL, '/chart/0/playlists');
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Playlist.fromJson(item)).toList();
  }
}
