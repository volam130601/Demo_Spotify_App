import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/firebase/playlist_new.dart';
import '../../../models/track.dart';

class PlaylistNewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'playlist_new';

  Future<void> addPlaylistNew(PlaylistNew item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updatePlaylistNew(PlaylistNew item) {
    return _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  Future<void> deletePlaylistNew(String id) {
    return _db.collection(collectionName).doc(id).delete();
  }

  Future<void> deleteAll() {
    return _db.collection(collectionName).get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Stream<List<PlaylistNew>> getPlaylistNews() {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PlaylistNew.fromSnapshot(doc)).toList());
  }

  Stream<List<Track>> getPlaylistNewByPlaylistId(
      String playlistId) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      List<Track> tracks = [];
      for (var e in snapshot.docs) {
        if (e.id == playlistId) {
          tracks.addAll(PlaylistNew.fromSnapshot(e).tracks!);
        }
      }
      return tracks;
    });
  }
}
