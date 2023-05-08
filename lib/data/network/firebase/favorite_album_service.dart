import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/firebase/favorite_album.dart';

class FavoriteAlbumService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'favorite_album';


  Stream<List<FavoriteAlbum>> getAlbumItemsByUserId(
      {required String userId}) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FavoriteAlbum.fromSnapshot(doc))
        .toList());
  }

  Future<void> addFavoriteAlbum(FavoriteAlbum item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updateFavoriteAlbum(FavoriteAlbum item) {
    return _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  Future<void> deleteFavoriteAlbum(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteFavoriteAlbumByAlbumId({required String albumId, required String userId}) {
    return _db
        .collection(collectionName)
        .where('albumId', isEqualTo: albumId)
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


}
