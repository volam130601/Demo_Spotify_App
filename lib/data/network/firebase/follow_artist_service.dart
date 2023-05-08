import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/follow_artist.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FollowArtistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'follow_artist';

  Future<void> addFollowArtist(FollowArtist item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updateFollowArtist(FollowArtist followArtist) {
    return _db
        .collection(collectionName)
        .doc(followArtist.id)
        .update(followArtist.toMap());
  }

  Future<void> deleteFollowArtist(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteAll() {
    return _db.collection(collectionName).get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Stream<FollowArtist> getFollowArtist() {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FollowArtist.fromSnapshot(doc)).first);
  }
}
