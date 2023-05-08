import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteSongService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'favorite_song';

  Stream<List<FavoriteSong>> getFavoriteSongs() {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoriteSong.fromSnapshot(doc))
            .toList());
  }

  Future<void> addFavoriteSong(FavoriteSong item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updateFavoriteSong(FavoriteSong item) {
    return _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  Future<void> deleteFavoriteSong(String itemId) {
    return _db.collection(collectionName).doc(itemId).delete();
  }

  Future<void> deleteFavoriteSongByTrackId(String trackId) {
    return _db
        .collection(collectionName)
        .where('trackId', isEqualTo: trackId)
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
