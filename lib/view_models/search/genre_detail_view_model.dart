import 'package:demo_spotify_app/data/response/api_response.dart';
import 'package:demo_spotify_app/models/genre/genre_search.dart';
import 'package:demo_spotify_app/repository/remote/genre_repository.dart';
import 'package:demo_spotify_app/view_models/track_play/multi_control_player_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/track.dart';
import '../../views/play_control/track_play.dart';
import '../../widgets/card_item_custom.dart';
import '../../widgets/navigator/slide_animation_page_route.dart';

class GenreDetailViewModel with ChangeNotifier {
  final _genres = GenreRepository();

  ApiResponse<List<Track>> tracks = ApiResponse.loading();
  List<Widget> widgetsGenreList = [];
  int genreId = 0;

  setTracks(ApiResponse<List<Track>> response) {
    tracks = response;
    notifyListeners();
  }

  Future<void> fetchTrackTopsByGenreIdApi(
      int currentGenreId, int index, int limit) async {
    await _genres
        .getTrackTopsByGenreID(currentGenreId.toString(), index, limit)
        .then((value) => setTracks(ApiResponse.completed(value)))
        .onError((error, stackTrace) =>
            setTracks(ApiResponse.error(error.toString())));
  }

  Future<void> fetchData(
      GenreSearch genreSearch, MultiPlayerViewModel multiPlayerValue) async {
    for (int i = 0; i < genreSearch.radios!.length; i++) {
      var item = genreSearch.radios![i];
      await fetchTrackTopsByGenreIdApi(item.id!.toInt(), 0, 10);
      if (tracks.data!.isNotEmpty && tracks.data != null) {
        List<Track> data = tracks.data!;
        widgetsGenreList.add(SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return CardItemCustom(
                image: data[index].album!.coverMedium as String,
                titleTop: data[index].title,
                titleBottom: data[index].artist!.name,
                centerTitle: true,
                onTap: () async {
                  await multiPlayerValue.initState(tracks: data, index: index);
                  //ignore: use_build_context_synchronously
                  Navigator.push(
                      context, SlideTopPageRoute(page: const TrackPlay()));
                },
              );
            },
          ),
        ));
      }
    }
    notifyListeners();
  }

  void checkGenreId(int currentGenreId) {
    if (currentGenreId != genreId) {
      widgetsGenreList = [];
      genreId = currentGenreId;
    }
  }
}
