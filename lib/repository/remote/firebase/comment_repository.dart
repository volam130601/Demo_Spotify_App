import 'package:demo_spotify_app/data/network/firebase/comment_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../models/firebase/comment/comment.dart';
import '../../../models/firebase/comment/comment_like.dart';
import '../../../models/firebase/comment/comment_reply.dart';
import '../../../models/firebase/comment/user_comment.dart';

class CommentRepository {
  CommentRepository._();

  static final CommentRepository instance = CommentRepository._();
  final _commentService = CommentService();

  Future<void> addCommentOfTrack(
      {required String content, required String trackId}) async {
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
    await _commentService.addComment(comment);
  }

  Future<void> addCommentReplyOfParentComment(
      {required String content, required Comment comment}) async {
    final user = FirebaseAuth.instance.currentUser;
    var uuid = const Uuid();
    comment.total = comment.total!.toInt() + 1;
    comment.commentReplies!.add(
      CommentReply(
        id: uuid.v4(),
        content: content,
        user: UserComment(
            id: user!.uid.toString(),
            name: user.displayName,
            photoURL: user.photoURL),
        commentLikes: [],
        createTime: DateTime.now().toString(),
      ),
    );
    await _commentService.updateComment(comment);
  }

  Future<void> addCommentReplyOfChildComment(
      {required String content,
      required Comment comment,
      required CommentReply commentReply}) async {
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
    await _commentService.updateComment(comment);
  }

  Future<void> deleteCommentParent(String commentId) async {
    await _commentService.deleteCommentById(commentId);
  }

  Future<void> deleteCommentChild(
      String commentId, CommentReply commentReply) async {
    Comment comment = await _commentService.getCommentById(commentId);
    comment.commentReplies!
        .removeWhere((element) => element.id == commentReply.id);
    await _commentService.updateComment(comment);
  }

  Stream<List<Comment>> getCommentsByTrackId(String trackId) {
    return _commentService.getCommentsByTrackId(trackId);
  }

  Future<int> getTotalCommentByTrackId(String trackId) {
    return _commentService.getTotalCommentByTrackId(trackId);
  }

  ///Begin: Comment Like
  Future<void> likeOfParentByUserId(Comment comment) async{
    var uuid = const Uuid();
    comment.commentLikes!.add(CommentLike(
      id: uuid.v4(),
      userId: FirebaseAuth.instance.currentUser!.uid,
    ));
    await _commentService.updateComment(comment);
  }

  Future<void> dislikeOfParentByUserId(
      {required Comment comment, required CommentLike commentLike}) async {
    comment.commentLikes!.remove(commentLike);
    await _commentService.updateComment(comment);
  }

  Future<void> likeOfChildByUserId(
      {required Comment comment, required CommentReply commentReply}) async {
    var uuid = const Uuid();
    comment.commentReplies?.forEach((element) {
      if (element == commentReply) {
        element.commentLikes!.add(CommentLike(
          id: uuid.v4(),
          userId: FirebaseAuth.instance.currentUser!.uid,
        ));
        return;
      }
    });
    await _commentService.updateComment(comment);
  }

  Future<void> dislikeOfChildByUserId(
      {required Comment comment,
        required CommentReply commentReply,
        required CommentLike commentLike}) async {
    comment.commentReplies?.forEach((element) {
      if (element == commentReply) {
        element.commentLikes!.remove(commentLike);
        return;
      }
    });
    comment.commentLikes!.remove(commentLike);
    await _commentService.updateComment(comment);
  }
}
