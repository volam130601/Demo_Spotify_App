import 'package:demo_spotify_app/data/network/firebase/favorite_song_service.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/album.dart';
import '../models/artist.dart';
import '../models/track.dart';

class FavoriteSongViewModel with ChangeNotifier {
  final List<Track> _favoriteSongs = [];

  List<Track> get favoriteSongs => _favoriteSongs;

  setTracks(List<Track> tracks) {
    _favoriteSongs.addAll(tracks);
    notifyListeners();
  }

  void loadFavoriteSong() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final Stream<List<FavoriteSong>> tracks =
        FavoriteSongService.instance.getItemsByUserId(userId);
    List<FavoriteSong> allTracks = [];
    await tracks.fold<List<FavoriteSong>>(
        allTracks, (acc, tracks) => acc..addAll(tracks));
    List<Track>? temp = [];
    for (var item in allTracks) {
      temp.add(
        Track(
          id: int.tryParse(item.trackId.toString()),
          title: item.title,
          artist: Artist(
              id: int.tryParse(item.artistId.toString()),
              name: item.artistName,
              pictureMedium: item.pictureMedium),
          album: Album(
              id: int.tryParse(item.albumId.toString()),
              coverMedium: item.coverMedium,
              coverXl: item.coverXl),
          preview: item.preview,
          type: item.type,
        ),
      );
    }
    setTracks(temp);
  }
}
