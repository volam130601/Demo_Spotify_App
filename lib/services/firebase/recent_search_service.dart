import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/recent_search.dart';

class RecentSearchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'recent_search';

  Future<void> addItem(RecentSearchItem item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(RecentSearchItem item) {
    return _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteAll() {
    return _db.collection(collectionName).get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Stream<List<RecentSearchItem>> getItems() {
    return _db.collection(collectionName).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => RecentSearchItem.fromMap(doc))
              .toList(),
        );
  }
}
