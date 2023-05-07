import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/follow_artist.dart';

import '../../../models/artist.dart';

class FollowArtistService {
  FollowArtistService._();

  static final FollowArtistService instance = FollowArtistService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'follow_artist';

  Future<void> addFollowArtist(FollowArtist item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> followingArtist(
      {required FollowArtist followArtist, required Artist artist}) {
    followArtist.artists!.add(artist);
    return _db
        .collection(collectionName)
        .doc(followArtist.id)
        .update(followArtist.toMap());
  }

  Future<void> unFollowingArtist(
      {required FollowArtist followArtist, required Artist artist}) {
    followArtist.artists!.removeWhere((element) => element.id == artist.id);
    return _db
        .collection(collectionName)
        .doc(followArtist.id)
        .update(followArtist.toMap());
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

  Stream<FollowArtist> getFollowArtistByUserId(String userId) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FollowArtist.fromSnapshot(doc)).first);
  }
}
