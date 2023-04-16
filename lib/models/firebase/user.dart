import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String? id;
  final String displayName;
  final String email;
  final String photoUrl;

  Users(
      {this.id,
      required this.displayName,
      required this.email,
      required this.photoUrl});

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  Users.fromJson(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        displayName = doc.data()!["displayName"],
        email = doc.data()!["email"],
        photoUrl = doc.data()!["photoUrl"];
}
