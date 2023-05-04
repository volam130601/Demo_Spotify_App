import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CommentService {
  CommentService._();

  static final CommentService instance = CommentService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionName = 'comment';

  Future<void> addCommentOfTrack(
      {required String content, required String trackId}) {
    final user = FirebaseAuth.instance.currentUser;
    Comment comment = Comment(
        trackId: trackId,
        content: content,
        commentReplies: [],
        createTime: DateTime.now().toString(),
        like: 0,
        total: 1,
        user: UserComment(
            id: user!.uid.toString(),
            name: user.displayName,
            photoURL: user.photoURL));
    return _db.collection(collectionName).doc(comment.id).set(comment.toMap());
  }

  Future<void> addCommentReplyOfParentComment(
      {required String content, required Comment comment}) {
    final user = FirebaseAuth.instance.currentUser;
    var uuid = const Uuid();
    comment.total = comment.total!.toInt() + 1;
    comment.commentReplies!.add(CommentReply(
      id: uuid.v4(),
      content: content,
      user: UserComment(
          id: user!.uid.toString(),
          name: user.displayName,
          photoURL: user.photoURL),
      like: 0,
      createTime: DateTime.now().toString(),
    ));
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  Future<void> addCommentReplyOfChildComment(
      {required String content,
      required Comment comment,
      required CommentReply commentReply}) {
    final user = FirebaseAuth.instance.currentUser;
    var uuid = const Uuid();
    comment.total = comment.total!.toInt() + 1;
    comment.commentReplies!.add(CommentReply(
      id: uuid.v4(),
      content: content,
      user: UserComment(
          id: user!.uid.toString(),
          name: user.displayName,
          photoURL: user.photoURL),
      like: 0,
      createTime: DateTime.now().toString(),
    ));
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  Future<void> editContentCommentByUserId(Comment item) {
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
}
