import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePlaylist {
  String? id;
  String? playlistId;
  String? title;
  String? userName;
  String? pictureMedium;
  String? userId;

  FavoritePlaylist(
      {this.id,
      this.playlistId,
      this.title,
      this.userName,
      this.pictureMedium,
      this.userId});

  factory FavoritePlaylist.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FavoritePlaylist(
      id: snapshot.id,
      playlistId: data['playlistId'],
      title: data['title'],
      userName: data['userName'],
      pictureMedium: data['pictureMedium'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playlistId': playlistId,
      'title': title,
      'userName': userName,
      'pictureMedium': pictureMedium,
      'userId': userId,
    };
  }
}