import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/comment/comment.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../models/firebase/comment/comment_like.dart';
import '../../../models/firebase/comment/comment_reply.dart';
import '../../../models/firebase/comment/user_comment.dart';

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
        total: 1,
        commentReplies: [],
        commentLikes: [],
        createTime: DateTime.now().toString(),
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
      commentLikes: [],
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
      commentLikes: [],
      createTime: DateTime.now().toString(),
    ));
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  Future<void> editContentCommentByUserId(Comment item) {
    return _db.collection(collectionName)
        .doc(item.id)
        .update(item.toMap());
  }

  ///Begin: Delete
  Future<void> deleteCommentParent(Comment comment) {
    return _db.collection(collectionName)
        .doc(comment.id)
        .delete();
  }

  Future<void> deleteCommentChild(Comment comment, CommentReply commentReply) {
    return _db.collection(collectionName)
        .doc(comment.id)
        .get()
        .then((snapshot) {
          Comment comment = Comment.fromSnapshot(snapshot);
          comment.commentReplies!.removeWhere((element) => element.id == commentReply.id);

          return _db
              .collection(collectionName)
              .doc(comment.id)
              .update(comment.toMap());
    });
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
  ///End: Delete

  ///Begin: Get comments, get total comment
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

  Future<int> getTotalCommentByTrackId(String trackId) async {
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
  ///End: Get comments, get total comment

  ///Begin: Comment Like
  Future<void> likeOfParentByUserId({required Comment comment}) {
    var uuid = const Uuid();
    comment.commentLikes!.add(CommentLike(
      id: uuid.v4(),
      userId: CommonUtils.userId,
    ));
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  Future<void> dislikeOfParentByUserId(
      {required Comment comment, required CommentLike commentLike}) {
    comment.commentLikes!.remove(commentLike);
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  Future<void> likeOfChildByUserId(
      {required Comment comment, required CommentReply commentReply}) {
    var uuid = const Uuid();
    comment.commentReplies?.forEach((element) {
      if (element == commentReply) {
        element.commentLikes!.add(CommentLike(
          id: uuid.v4(),
          userId: CommonUtils.userId,
        ));
        return;
      }
    });
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  Future<void> dislikeOfChildByUserId(
      {required Comment comment,
      required CommentReply commentReply,
      required CommentLike commentLike}) {
    comment.commentReplies?.forEach((element) {
      if (element == commentReply) {
        element.commentLikes!.remove(commentLike);
        return;
      }
    });
    comment.commentLikes!.remove(commentLike);
    return _db
        .collection(collectionName)
        .doc(comment.id)
        .update(comment.toMap());
  }

  ///End: Comment Like
}
