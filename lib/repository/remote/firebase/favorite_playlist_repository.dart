import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/network/firebase/favorite_playlist_service.dart';
import '../../../models/firebase/favorite_playlist.dart';
import '../../../models/playlist.dart';

class FavoritePlaylistRepository {
  FavoritePlaylistRepository._();

  static final FavoritePlaylistRepository instance =
      FavoritePlaylistRepository._();
  final _favoritePlaylistService = FavoritePlaylistService();

  Future<void> addFavoritePlaylist(Playlist playlist) async {
    await _favoritePlaylistService.addFavoritePlaylist(FavoritePlaylist(
      id: DateTime.now().toString(),
      playlistId: playlist.id.toString(),
      title: playlist.title,
      userName: (playlist.user != null)
          ? playlist.user!.name.toString()
          : playlist.creator!.name.toString(),
      pictureMedium: playlist.pictureMedium,
      userId: FirebaseAuth.instance.currentUser!.uid,
    ));
  }

  Future<void> updateFavoritePlaylist(FavoritePlaylist favoritePlaylist) async {
    await _favoritePlaylistService.updateFavoritePlaylist(favoritePlaylist);
  }

  Future<void> deleteFavoritePlaylist(String favoritePlaylistId) async {
    await _favoritePlaylistService.deleteFavoritePlaylist(favoritePlaylistId);
  }

  Future<void> deleteFavoritePlaylistByPlaylistId(String playlistId) async {
    await _favoritePlaylistService
        .deleteFavoritePlaylistByPlaylistId(playlistId);
  }

  Future<void> deleteAll() async {
    await _favoritePlaylistService.deleteAll();
  }

  Stream<List<FavoritePlaylist>> getPlaylistItemsByUserId(
      {required String userId}) {
    return _favoritePlaylistService.getPlaylistItemsByUserId(userId: userId);
  }
}
