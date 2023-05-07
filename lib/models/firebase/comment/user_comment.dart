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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoURL': photoURL,
    };
  }
}