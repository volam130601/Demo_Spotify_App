import 'package:cloud_firestore/cloud_firestore.dart';

import '../artist.dart';

class FollowArtist {
  String? id;
  String? userId;
  List<Artist>? artists;

  FollowArtist({this.id, this.userId, this.artists});

  factory FollowArtist.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return FollowArtist(
      id: snapshot.id,
      userId: data['userId'],
      artists: data["artists"] == null
          ? null
          : (data["artists"] as List).map((e) => Artist.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'artists': (artists != null)
          ? artists?.map((e) => e.toJson()).toList()
          : <Artist>[],
    };
  }
}
