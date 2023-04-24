import 'package:demo_spotify_app/data/network/network_api_services.dart';
import 'package:demo_spotify_app/models/album.dart';

import '../../utils/app_url.dart';

class AlbumRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<Album> getAlbumByID(int albumID) async {
    var url = Uri.https(AppUrl.baseURL, '/album/$albumID');
    final dynamic response = await _apiServices.getGetApiResponse(url);
    return Album.fromJson(response);
  }
}
