import 'package:demo_spotify_app/data/network/network_api_services.dart';
import 'package:demo_spotify_app/models/album.dart';

import '../../models/track.dart';
import '../../utils/app_url.dart';

class AlbumRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Album> getAlbumById(int albumID) async {
    var url = Uri.https(AppUrl.baseURL, '/album/$albumID');
    final dynamic response = await _apiServices.getGetApiResponse(url);
    return Album.fromJson(response);
  }

  Future<List<Track>> getTracksByAlbumId(int albumID) async {
    var url =
        Uri.https(AppUrl.baseURL, '/album/$albumID/tracks',
            {'index' : '0' , 'limit': '1000'}
        );
    final response = await _apiServices.getGetApiResponse(url);
    final List<dynamic> items = response['data'];
    return items.map((item) => Track.fromJson(item)).toList();
  }

}
