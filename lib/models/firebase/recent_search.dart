import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearchItem {
  String? id;
  String? itemId;
  String? title;
  String? image;
  String? type;
  String? userId;
  ArtistSearch? artistSearch;
  AlbumSearch? albumSearch;
  PlaylistSearch? playlistSearch;

  RecentSearchItem({
    this.id,
    this.itemId,
    this.title,
    this.image,
    this.type,
    this.userId,
    this.artistSearch,
    this.albumSearch,
    this.playlistSearch,
  });

  factory RecentSearchItem.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return RecentSearchItem(
      id: snapshot.id,
      itemId: data['itemId'],
      title: data['title'],
      image: data['image'],
      type: data['type'],
      userId: data['userId'],
      artistSearch: data['artistSearch'] != null
          ? ArtistSearch.fromJson(data['artistSearch'])
          : null,
      albumSearch: data['albumSearch'] != null
          ? AlbumSearch.fromJson(data['albumSearch'])
          : null,
      playlistSearch: data['playlistSearch'] != null
          ? PlaylistSearch.fromJson(data['playlistSearch'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'title': title,
      'image': image,
      'type': type,
      'userId': userId,
      'artistSearch': artistSearch?.toMap(),
      'albumSearch': albumSearch?.toMap(),
      'playlistSearch': playlistSearch?.toMap(),
    };
  }
}

class ArtistSearch {
  int? id;
  String? name;
  String? picture;
  String? pictureSmall;
  String? pictureMedium;
  String? pictureBig;
  String? pictureXl;

  ArtistSearch({
    this.id,
    this.name,
    this.picture,
    this.pictureSmall,
    this.pictureMedium,
    this.pictureBig,
    this.pictureXl,
  });

  factory ArtistSearch.fromJson(Map<String, dynamic> json) {
    return ArtistSearch(
      id: json['id'],
      name: json['name'],
      picture: json['picture'],
      pictureSmall: json['pictureSmall'],
      pictureMedium: json['pictureMedium'],
      pictureBig: json['pictureBig'],
      pictureXl: json['pictureXl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'picture': picture,
      'pictureSmall': pictureSmall,
      'pictureMedium': pictureMedium,
      'pictureBig': pictureBig,
      'pictureXl': pictureXl,
    };
  }
}

class AlbumSearch {
  int? id;
  String? title;
  String? cover;
  String? coverSmall;
  String? coverMedium;
  String? coverBig;
  String? coverXl;

  AlbumSearch({
    this.id,
    this.title,
    this.cover,
    this.coverSmall,
    this.coverMedium,
    this.coverBig,
    this.coverXl,
  });

  factory AlbumSearch.fromJson(Map<String, dynamic> json) {
    return AlbumSearch(
      id: json['id'],
      title: json['title'],
      cover: json['cover'],
      coverSmall: json['coverSmall'],
      coverMedium: json['coverMedium'],
      coverBig: json['coverBig'],
      coverXl: json['coverXl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'cover': cover,
      'coverSmall': coverSmall,
      'coverMedium': coverMedium,
      'coverBig': coverBig,
      'coverXl': coverXl,
    };
  }
}

class PlaylistSearch {
  int? id;
  String? title;
  String? picture;
  String? pictureSmall;
  String? pictureMedium;
  String? pictureBig;
  String? pictureXl;
  String? userName;

  PlaylistSearch({
    this.id,
    this.title,
    this.picture,
    this.pictureSmall,
    this.pictureMedium,
    this.pictureBig,
    this.pictureXl,
    this.userName,
  });

  factory PlaylistSearch.fromJson(Map<String, dynamic> json) {
    return PlaylistSearch(
      id: json['id'],
      title: json['title'],
      picture: json['picture'],
      pictureSmall: json['pictureSmall'],
      pictureMedium: json['pictureMedium'],
      pictureBig: json['pictureBig'],
      pictureXl: json['pictureXl'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'picture': picture,
      'pictureSmall': pictureSmall,
      'pictureMedium': pictureMedium,
      'pictureBig': pictureBig,
      'pictureXl': pictureXl,
      'userName': userName,
    };
  }
}
