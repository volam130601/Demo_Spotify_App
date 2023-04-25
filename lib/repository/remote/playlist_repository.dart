import 'package:demo_spotify_app/models/playlist.dart';

import '../../data/network/network_api_services.dart';
import '../../models/track.dart';
import '../../utils/app_url.dart';

class PlaylistRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Playlist> getPlaylistByID(int playlistId) async {
    var url = Uri.https(AppUrl.baseURL, '/playlist/$playlistId');
    final dynamic response = await _apiServices.getGetApiResponse(url);
    return Playlist.fromJson(response);
  }

  Future<List<Track>> getTracksByPlaylistId(
      int playlistId, int index, int limit) async {
    var url = Uri.https(AppUrl.baseURL, '/playlist/$playlistId/tracks',
        {'limit': '$limit', 'index': '$index'});
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }
}
