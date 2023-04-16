import 'package:demo_spotify_app/data/network/network_api_services.dart';
import 'package:demo_spotify_app/models/artist.dart';

import '../models/genre/genre.dart';
import '../models/genre/genre_search.dart';
import '../models/track.dart';
import '../utils/app_url.dart';

class GenreRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<List<GenreSearch>> getGenreSearches() async {
    var url = Uri.https(AppUrl.baseURL, '/radio/genres');
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => GenreSearch.fromJson(item)).toList();
  }

  Future<List<Genre>> getGenreChildList(String genreId) async {
    var url = Uri.https(AppUrl.baseURL, '/genre/$genreId/radios');
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Genre.fromJson(item)).toList();
  }

  Future<List<Artist>> getArtistsByGenreId(String genreId) async {
    var url = Uri.https(AppUrl.baseURL, '/genre/$genreId/artists');
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Artist.fromJson(item)).toList();
  }

  Future<List<Track>> getTrackTopsByGenreID(String genreID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/radio/$genreID/tracks',
        {'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }

}
