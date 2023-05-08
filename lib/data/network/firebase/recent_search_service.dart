import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/recent_search.dart';

class RecentSearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'recent_search';

  Future<void> addRecentSearch(RecentSearchItem recentSearchItem) {
    return _db
        .collection(collectionName)
        .doc(recentSearchItem.id)
        .set(recentSearchItem.toMap());
  }

  Future<void> updateRecentSearch(RecentSearchItem recentSearchItem) {
    return _db
        .collection(collectionName)
        .doc(recentSearchItem.id)
        .update(recentSearchItem.toMap());
  }

  Future<void> deleteRecentSearch(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteAll() {
    return _db.collection(collectionName).get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<bool> isCheckExists(int itemId, String userId) async {
    QuerySnapshot querySnapshot = await _db
        .collection(collectionName)
        .where('itemId', isEqualTo: itemId)
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Stream<List<RecentSearchItem>> getItemsByUserId(String userId) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RecentSearchItem.fromSnapshot(doc))
            .toList());
  }
}
