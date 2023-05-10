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
        title: 'Hạ buồn vương nắng',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/8e917792796412110f79996f4ae53b09/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
        title: '100% Hello Maestro',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/8b9e97882dfe87eff081d6ddcc373887/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
        title: 'Top Hits Gospel',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/aa171bbc81a2cf77e3efd697d110177b/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
        title: 'Top 50 Sertanejo',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/988baaea88b6e1b12cadfe20159bca55/250x250-000000-80-0-0.jpg'),
    RecentPlayed(
        title: 'Making my way bake',
        picture:
            'https://e-cdns-images.dzcdn.net/images/playlist/298c9544c370218c9bddbe3dde3e5aee/250x250-000000-80-0-0.jpg'),
  ];
}
