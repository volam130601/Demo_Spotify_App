import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteSong {
  String? id;
  String? trackId;
  String? albumId;
  String? artistId;
  String? title;
  String? artistName;
  String? pictureMedium;
  String? coverMedium;
  String? coverXl;
  String? preview;
  String? type;
  String? userId;


  FavoriteSong(
      {this.id,
      this.trackId,
      this.albumId,
      this.artistId,
      this.title,
      this.artistName,
      this.pictureMedium,
      this.coverMedium,
      this.coverXl,
      this.preview,
      this.type,
      this.userId});

  factory FavoriteSong.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FavoriteSong(
      id: snapshot.id,
      trackId: data['trackId'],
      albumId: data['albumId'],
      artistId: data['artistId'],
      title: data['title'],
      artistName: data['artistName'],
      pictureMedium: data['pictureMedium'],
      coverMedium: data['coverMedium'],
      coverXl: data['coverXl'],
      preview: data['preview'],
      type: data['type'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'albumId': albumId,
      'artistId': artistId,
      'title': title,
      'artistName': artistName,
      'pictureMedium': pictureMedium,
      'coverMedium': coverMedium,
      'coverXl': coverXl,
      'preview': preview,
      'type': type,
      'userId': userId,
    };
  }
}
