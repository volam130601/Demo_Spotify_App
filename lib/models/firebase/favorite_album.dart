import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteAlbum {
  String? id;
  String? albumId;
  String? title;
  String? artistName;
  String? coverMedium;
  String? userId;

  FavoriteAlbum(
      {this.id,
      this.albumId,
      this.title,
      this.artistName,
      this.coverMedium,
      this.userId});

  factory FavoriteAlbum.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FavoriteAlbum(
      id: snapshot.id,
      albumId: data['albumId'],
      title: data['title'],
      artistName: data['artistName'],
      coverMedium: data['coverMedium'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'albumId': albumId,
      'title': title,
      'artistName': artistName,
      'coverMedium': coverMedium,
      'userId': userId,
    };
  }
}