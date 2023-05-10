import 'package:cloud_firestore/cloud_firestore.dart';

class RecentPlayed {
  String? id;
  String? title;
  String? picture;
  String? userId;

  RecentPlayed({this.id, this.picture, this.title, this.userId});

  factory RecentPlayed.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RecentPlayed(
      id: snapshot.id,
      title: data['title'],
      picture: data['picture'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'picture': picture,
      'userId': userId,
    };
  }

  static final List<RecentPlayed> recentPlayed = [
    RecentPlayed(
        id: '3990906526',
        title: 'Making my way bake',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/298c9544c370218c9bddbe3dde3e5aee/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
        id: '3227703762',
        title: '100% Taylor Swift',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/5bdefa05ea572bbd85e12dc92b8ff64e/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
        id: '2293317046',
        title: 'Top Hits Gospel',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/aa171bbc81a2cf77e3efd697d110177b/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
      id: '3133469542',
        title: '100% Justin Bieber',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/4c94d37d457d99d324d5823dfd9f66cf/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
      id: '5182240424',
        title: '100% Alan Walker',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/8f0e30cacc8e3df1b55fe7f3b3489f22/250x250-000000-80-0-0.jpg'),
      RecentPlayed(
      id: '3133295502',
        title: '100% Martin Garrix',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/f1824a3f5d26b1986a7d1a13c57761e6/250x250-000000-80-0-0.jpg'),
  ];
}
