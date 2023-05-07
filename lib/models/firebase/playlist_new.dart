import 'package:cloud_firestore/cloud_firestore.dart';

import '../track.dart';

class PlaylistNew {
  String? id;
  String? title;
  String? picture;
  String? userName;
  String? releaseDate;
  String? userId;
  bool? isDownloading;
  bool? isPrivate;
  List<Track>? tracks;

  PlaylistNew({
    this.id,
    this.title,
    this.picture,
    this.userName,
    this.releaseDate,
    this.userId,
    this.isDownloading,
    this.isPrivate,
    this.tracks,
  });

  factory PlaylistNew.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return PlaylistNew(
      id: snapshot.id,
      title: data['title'],
      picture: data['picture'],
      userName: data['userName'],
      releaseDate: data['releaseDate'],
      userId: data['userId'],
      isDownloading: data['isDownloading'],
      isPrivate: data['isPrivate'],
      tracks: data["tracks"] == null
          ? null
          : (data["tracks"] as List).map((e) => Track.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'picture': picture,
      'userName': userName,
      'releaseDate': releaseDate,
      'userId': userId,
      'isDownloading': isDownloading,
      'isPrivate': isPrivate,
      'tracks':
          (tracks != null) ? tracks?.map((e) => e.toJson()).toList() : <Track>[],
    };
  }
}
