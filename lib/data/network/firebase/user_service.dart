import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/user.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'user';

  Future<void> addUsers(Users item) {
    return _db.collection(collectionName).doc(item.id).set(item.toJson());
  }

  Future<void> editProfile(String name) {
    final item = CommonUtils.user;
    Users user =
        Users(displayName: name, email: item.email!, photoUrl: item.photoURL!);
    return _db.collection(collectionName).doc(user.id).update(user.toJson());
  }

  Future<Users> getUser(String userId) async {
    return _db
        .collection(collectionName)
        .doc(userId)
        .get()
        .then((snapshot) => Users.fromJson(snapshot));
  }

  Stream<List<Users>> getItems() {
    return _db.collection(collectionName).snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Users.fromJson(doc)).toList(),
        );
  }
}
