import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'user';

   Future<void> addItem(Users item) {
    return _db.collection(collectionName).doc(item.id).set(item.toJson());
  }

  Future<void> updateItem(Users item) {
    return _db.collection(collectionName).doc(item.id).update(item.toJson());
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

  Future<void> getUserById(String id) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return _db.collection(collectionName)
      .doc(id)
      .get().then((snapshot) {
        Users user = Users.fromJson(snapshot);
        currentUser!.updateDisplayName(user.displayName);
      });
  }

  Stream<List<Users>> getItems() {
    return _db.collection(collectionName).snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => Users.fromJson(doc))
          .toList(),
    );
  }
}
