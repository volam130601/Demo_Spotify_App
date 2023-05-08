import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/favorite_playlist.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritePlaylistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'favorite_playlist';

  Stream<List<FavoritePlaylist>> getPlaylistItemsByUserId(
      {required String userId}) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoritePlaylist.fromSnapshot(doc))
            .toList());
  }

  Future<void> addFavoritePlaylist(FavoritePlaylist favoritePlaylist) {
    return _db
        .collection(collectionName)
        .doc(favoritePlaylist.id)
        .set(favoritePlaylist.toMap());
  }

  Future<void> updateFavoritePlaylist(FavoritePlaylist favoritePlaylist) {
    return _db
        .collection(collectionName)
        .doc(favoritePlaylist.id)
        .update(favoritePlaylist.toMap());
  }

  Future<void> deleteFavoritePlaylist(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteFavoritePlaylistByPlaylistId(String playlistId) {
    return _db
        .collection(collectionName)
        .where('playlistId', isEqualTo: playlistId)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.first.reference.delete();
    });
  }

  Future<void> deleteAll() {
    return _db.collection(collectionName).get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}
