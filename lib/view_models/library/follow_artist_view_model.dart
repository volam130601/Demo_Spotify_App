import 'package:demo_spotify_app/repository/remote/artist_repository.dart';
import 'package:flutter/material.dart';

import '../../data/response/api_response.dart';
import '../../models/artist.dart';

class FollowArtistViewModel with ChangeNotifier {
  final _artists = ArtistRepository();

  ApiResponse<List<Artist>> artists = ApiResponse.loading();

  setArtists(ApiResponse<List<Artist>> response) {
    artists = response;
    notifyListeners();
  }

  Future<void> fetchSearchArtists(
      String searchKey, int index, int limit) async {
    await _artists
        .getSearchArtists(searchKey, index, limit)
        .then((value) => setArtists(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setArtists(ApiResponse.error(error.toString())));
  }
}
