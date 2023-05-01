import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';

import '../../../models/firebase/playlist_new.dart';
import '../../../models/track.dart';

class PlaylistNewService {
  PlaylistNewService._();

  static final PlaylistNewService instance = PlaylistNewService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'playlist_new';

  Future<void> addItem(PlaylistNew item) {
    return _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  Future<void> updateItem(PlaylistNew item) {
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

  Stream<List<PlaylistNew>> getItemsByUserId(String userId) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PlaylistNew.fromSnapshot(doc)).toList());
  }

//TODO: Fix bug render tracks with Stream builder
  Stream<List<Track>> getPlaylistNewByPlaylistIdAndUserId(String playlistId ,String userId) {
    return _db
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          List<Track> tracks = [];
          for (var e in snapshot.docs) {
            if(e.id == playlistId) {
              tracks.addAll(PlaylistNew.fromSnapshot(e).tracks!);
            }
          }
          return tracks;
        });
  }


}
