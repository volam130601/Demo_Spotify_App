class CommentLike {
  String? id;
  String? userId;

  CommentLike({this.id, this.userId});
  factory CommentLike.fromJson(Map<String, dynamic> json) {
    return CommentLike(
      id: json['id'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
    };
  }
}
