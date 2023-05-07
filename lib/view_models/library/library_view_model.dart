import 'package:flutter/material.dart';

import '../../data/response/api_response.dart';
import '../../models/track.dart';
import '../../repository/remote/search_repository.dart';

class LibraryViewModel with ChangeNotifier {
  final _trackSuggest = SearchRepository();

  ApiResponse<List<Track>> trackSuggests = ApiResponse.loading();

  setTracks(ApiResponse<List<Track>> response) {
    trackSuggests = response;
    notifyListeners();
  }

  Future<void> fetchTrackSuggestApi(String searchKey, int index, int limit) async {
    await _trackSuggest
        .getSearchTracks(searchKey, index, limit)
        .then((value) => setTracks(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTracks(ApiResponse.error(error.toString())));
  }
}
