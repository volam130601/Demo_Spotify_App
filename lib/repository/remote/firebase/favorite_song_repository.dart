import 'package:demo_spotify_app/data/network/firebase/favorite_song_service.dart';
import 'package:demo_spotify_app/models/album.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/track.dart';

class FavoriteSongRepository {
  FavoriteSongRepository._();

  static final FavoriteSongRepository instance = FavoriteSongRepository._();
  final _favoriteSongService = FavoriteSongService();

  Future<void> addFavoriteSong(Track track ,Album album) async {
    await _favoriteSongService.addFavoriteSong(FavoriteSong(
      id: DateTime.now().toString(),
      trackId: track.id.toString(),
      albumId: album.id.toString(),
      artistId: track.artist!.id.toString(),
      title: track.title,
      albumTitle: album.title.toString(),
      artistName: track.artist!.name,
      pictureMedium: track.artist!.pictureMedium,
      coverMedium: album.coverMedium.toString(),
      coverXl: album.coverXl.toString(),
      preview: track.preview,
      releaseDate: album.releaseDate.toString(),
      userId: FirebaseAuth.instance.currentUser!.uid,
      type: 'track',
    ));
  }

  Future<void> updateFavoriteSong(FavoriteSong item) async {
    await _favoriteSongService.updateFavoriteSong(item);
  }

  Future<void> deleteFavoriteSong(String itemId) async {
    await _favoriteSongService.deleteFavoriteSong(itemId);
  }

  Future<void> deleteFavoriteSongByTrackId(String trackId) async {
    await _favoriteSongService.deleteFavoriteSongByTrackId(trackId);
  }

  Future<void> deleteAll() async {
    await _favoriteSongService.deleteAll();
  }

  Stream<List<FavoriteSong>> getFavoriteSongs() {
    return _favoriteSongService.getFavoriteSongs();
  }
}
