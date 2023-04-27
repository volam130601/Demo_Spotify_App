import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/favorite_playlist.dart';

class FavoritePlaylistService {
  FavoritePlaylistService._();

  static final FavoritePlaylistService instance = FavoritePlaylistService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'favorite_playlist';

  Future<void> addItem(FavoritePlaylist item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(FavoritePlaylist item) {
    return _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteItemByPlaylistId(String playlistId, String userId) {
    return _db
        .collection(collectionName)
        .where('playlistId', isEqualTo: playlistId)
        .where('userId', isEqualTo: userId)
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
}
