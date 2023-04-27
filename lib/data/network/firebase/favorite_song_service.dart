import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';

class FavoriteSongService {
  FavoriteSongService._();

  static final FavoriteSongService instance = FavoriteSongService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'favorite_song';

  Future<void> addItem(FavoriteSong item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(FavoriteSong item) {
    return _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteItemByTrackId(String trackId, String userId) {
    return _db
        .collection(collectionName)
        .where('trackId', isEqualTo: trackId)
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

  Future<bool> isCheckExists(String trackId, String userId) async {
    QuerySnapshot querySnapshot = await _db
        .collection(collectionName)
        .where('trackId', isEqualTo: trackId)
        .where('userId', isEqualTo: userId)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Stream<List<FavoriteSong>> getItemsByUserId(String userId) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoriteSong.fromSnapshot(doc))
            .toList());
  }
}
