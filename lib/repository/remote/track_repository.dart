import 'package:demo_spotify_app/data/network/network_api_services.dart';
import 'package:demo_spotify_app/models/track.dart';

import '../../utils/app_url.dart';

class TrackRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Track> getTrackByID(int trackID) async {
    var url = Uri.https(AppUrl.baseURL, '/track/$trackID');
    final dynamic response = await _apiServices.getGetApiResponse(url);
    return Track.fromJson(response);
  }

  Future<List<Track>> getTracksByPlaylistID(
      int playlistID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/playlist/$playlistID/tracks',
        {'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }

  Future<int> getTotalTracksByPlaylistId(int playlistID) async {
    var url = Uri.https(AppUrl.baseURL, '/playlist/$playlistID/tracks',
        {'limit': '1', 'index': '0'});
    final response = await _apiServices.getGetApiResponse(url);
    final dynamic total = response['total'];
    return total;
  }

  Future<List<Track>> getTracksByAlbumID(
      int albumID, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/album/$albumID/tracks',
        {'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }
}
