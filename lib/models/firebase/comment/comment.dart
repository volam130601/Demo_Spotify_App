import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_spotify_app/models/firebase/comment/user_comment.dart';

import 'comment_reply.dart';
import 'comment_like.dart';

class Comment {
  String? id;
  String? trackId;
  String? content;
  int? total;
  String? createTime;
  UserComment? user;
  List<CommentReply>? commentReplies;
  List<CommentLike>? commentLikes;

  Comment({
    this.id,
    this.trackId,
    this.content,
    this.total,
    this.createTime,
    this.user,
    this.commentReplies,
    this.commentLikes,
  });

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Comment(
      id: snapshot.id,
      trackId: data['trackId'],
      content: data['content'],
      total: data['total'],
      createTime: data['createTime'],
      user: data['user'] != null ? UserComment.fromJson(data['user']) : null,
      commentReplies: data["commentReplies"] == null
          ? null
          : (data["commentReplies"] as List)
              .map((e) => CommentReply.fromJson(e))
              .toList(),
      commentLikes: data["commentLikes"] == null
          ? null
          : (data["commentLikes"] as List)
              .map((e) => CommentLike.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'content': content,
      'total': total,
      'createTime': createTime,
      'user': user?.toJson(),
      'commentReplies': (commentReplies != null)
          ? commentReplies?.map((e) => e.toJson()).toList()
          : <CommentReply>[],
      'commentLikes': (commentLikes != null)
          ? commentLikes?.map((e) => e.toJson()).toList()
          : <CommentLike>[],
    };
  }
}
