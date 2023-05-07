import 'package:demo_spotify_app/models/firebase/comment/user_comment.dart';

import 'comment_like.dart';

class CommentReply {
  String? id;
  String? content;
  String? createTime;
  UserComment? user;
  List<CommentLike>? commentLikes;

  CommentReply({
    this.id,
    this.user,
    this.content,
    this.createTime,
    this.commentLikes,
  });

  factory CommentReply.fromJson(Map<String, dynamic> json) {
    return CommentReply(
      id: json['id'],
      content: json['content'],
      createTime: json['createTime'],
      user: json['user'] != null ? UserComment.fromJson(json['user']) : null,
      commentLikes: json["commentLikes"] == null
          ? null
          : (json["commentLikes"] as List)
          .map((e) => CommentLike.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createTime': createTime,
      'user': user?.toJson(),
      'commentLikes': (commentLikes != null)
          ? commentLikes?.map((e) => e.toJson()).toList()
          : <CommentLike>[],
    };
  }
}
