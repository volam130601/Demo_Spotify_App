import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String? id;
  final String fullName;
  final String email;

  Users({
    required this.id,
    required this.fullName,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }

  Users.fromJson(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        fullName = doc.data()!["fullName"],
        email = doc.data()!["email"];
}
