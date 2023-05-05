import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? displayName;
  String? email;
  String? photoUrl;

  Users({this.id, this.displayName, this.email, this.photoUrl});

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory Users.fromJson(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Users(
      id: snapshot.id,
      displayName: data['displayName'],
      email: data['email'],
      photoUrl: data['photoUrl'],
    );
  }
}
