import 'package:demo_spotify_app/data/network/firebase/favorite_album_service.dart';
import 'package:demo_spotify_app/models/album.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/firebase/favorite_album.dart';

class FavoriteAlbumRepository {
  FavoriteAlbumRepository._();

  static final FavoriteAlbumRepository instance = FavoriteAlbumRepository._();
  final _favoriteAlbumService = FavoriteAlbumService();

  Future<void> addFavoriteAlbum({required Album album}) async {
    FavoriteAlbum favoriteAlbum = FavoriteAlbum(
      id: DateTime.now().toString(),
      albumId: album.id.toString(),
      title: album.title,
      artistName: album.artist!.name,
      coverMedium: album.coverMedium,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _favoriteAlbumService.addFavoriteAlbum(favoriteAlbum);
  }

  Future<void> updateFavoriteAlbum(FavoriteAlbum favoriteAlbum) async {
    await _favoriteAlbumService.updateFavoriteAlbum(favoriteAlbum);
  }

  Future<void> deleteFavoriteAlbum(String favoriteAlbumId) async {
    await _favoriteAlbumService.deleteFavoriteAlbum(favoriteAlbumId);
  }

  Future<void> deleteFavoriteAlbumByAlbumId(String albumId, String userId) {
    return _favoriteAlbumService.deleteFavoriteAlbumByAlbumId(
        albumId: albumId, userId: userId);
  }

  Future<void> deleteAll() {
    return _favoriteAlbumService.deleteAll();
  }

  Stream<List<FavoriteAlbum>> getAlbumItemsByUserId({required String userId}) {
    return _favoriteAlbumService.getAlbumItemsByUserId(userId: userId);
  }
}
