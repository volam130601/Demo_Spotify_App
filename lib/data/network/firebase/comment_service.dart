import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/comment/comment.dart';

class CommentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'comment';

  Future<Comment> getCommentById(String commentId) {
    return _db
        .collection(collectionName)
        .doc(commentId)
        .get()
        .then((snapshot) => Comment.fromSnapshot(snapshot));
  }

  Stream<List<Comment>> getCommentsByTrackId(String trackId) {
    return _db
        .collection(collectionName)
        .where('trackId', isEqualTo: trackId)
        .snapshots()
        .map((snapshot) {
      List<Comment> comments =
          snapshot.docs.map((doc) => Comment.fromSnapshot(doc)).toList();
      comments.sort(
        (a, b) => a.createTime!.compareTo(b.createTime!),
      );
      return comments.isNotEmpty ? comments.reversed.toList() : [];
    });
  }

  Future<int> getTotalCommentByTrackId(String trackId) {
    return _db
        .collection(collectionName)
        .where('trackId', isEqualTo: trackId)
        .get()
        .then((value) {
      List<Comment> comments =
          value.docs.map((doc) => Comment.fromSnapshot(doc)).toList();
      int total = comments.fold(0, (sum, item) => sum + item.total!);
      return total;
    });
  }

  Future<void> addComment(Comment comment) {
    return _db.collection(collectionName).doc(comment.id).set(comment.toMap());
  }

  Future<void> updateComment(Comment comment) {
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  Future<void> deleteCommentById(String commentId) {
    return _db.collection(collectionName).doc(commentId).delete();
  }
}
