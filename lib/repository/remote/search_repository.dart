import 'package:demo_spotify_app/models/playlist.dart';

import '../../data/network/network_api_services.dart';
import '../../models/album.dart';
import '../../models/artist.dart';
import '../../models/track.dart';
import '../../utils/app_url.dart';

class SearchRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<List<Track>> getSearchTracks(
      String searchKey, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/search/track',
        {'q': searchKey, 'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }

  Future<List<Album>> getSearchAlbums(
      String searchKey, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/search/album',
        {'q': searchKey, 'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Album.fromJson(item)).toList();
  }

  Future<List<Artist>> getSearchArtists(
      String searchKey, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/search/artist',
        {'q': searchKey, 'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Artist.fromJson(item)).toList();
  }

  Future<List<Playlist>> getSearchPlaylists(
      String searchKey, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/search/playlist',
        {'q': searchKey, 'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Playlist.fromJson(item)).toList();
  }
}
