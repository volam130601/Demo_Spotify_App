import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  String? trackId;
  String? content;
  int? like;
  int? total;
  String? createTime;
  UserComment? user;
  List<CommentReply>? commentReplies;

  Comment(
      {this.id,
      this.trackId,
      this.user,
      this.content,
      this.createTime,
      this.like,
      this.commentReplies,
      this.total,
      });

  factory Comment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Comment(
      id: snapshot.id,
      trackId: data['trackId'],
      content: data['content'],
      like: data['like'],
      total: data['total'],
      createTime: data['createTime'],
      user: data['user'] != null
          ? UserComment.fromJson(data['user'])
          : null,
      commentReplies: data["commentReplies"] == null
          ? null
          : (data["commentReplies"] as List).map((e) => CommentReply.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'content': content,
      'like': like,
      'total': total,
      'createTime': createTime,
      'user': user?.toMap(),
      'commentReplies': (commentReplies != null)
          ? commentReplies?.map((e) => e.toJson()).toList()
          : <CommentReply>[],
    };
  }
}

class CommentReply {
  String? id;
  String? content;
  int? like;
  String? createTime;
  UserComment? user;

  CommentReply({this.id, this.user, this.content, this.like, this.createTime});
  factory CommentReply.fromJson(Map<String, dynamic> json) {
    return CommentReply(
      id: json['id'],
      content: json['content'],
      like: json['like'],
      createTime: json['createTime'],
      user: json['user'] != null
          ? UserComment.fromJson(json['user'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'like': like,
      'createTime': createTime,
      'user': user?.toMap(),
    };
  }
}

class UserComment {
  String? id;
  String? name;
  String? photoURL;

  UserComment({this.id, this.name, this.photoURL});


  factory UserComment.fromJson(Map<String, dynamic> json) {
    return UserComment(
      id: json['id'],
      name: json['name'],
      photoURL: json['photoURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoURL': photoURL,
    };
  }
}
