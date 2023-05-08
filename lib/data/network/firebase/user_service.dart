import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'user';

  Future<void> addUser(Users item) {
    return _db.collection(collectionName).doc(item.id).set(item.toJson());
  }

  Future<void> updateUser({required Users user}) {
    return _db.collection(collectionName).doc(user.id).update(user.toJson());
  }

  Future<Users> getUser(String email) async {
    return _db
        .collection(collectionName)
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => Users.fromJson(snapshot.docs.first));
  }
}
