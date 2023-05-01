import 'artist.dart';

class Album {
  int? id;
  String? title;
  String? upc;
  String? link;
  String? share;
  String? cover;
  String? coverSmall;
  String? coverMedium;
  String? coverBig;
  String? coverXl;
  String? md5Image;
  int? genreId;
  Genres? genres;
  String? label;
  int? nbTracks;
  int? duration;
  int? fans;
  String? releaseDate;
  String? recordType;
  bool? available;
  String? tracklist;
  bool? explicitLyrics;
  int? explicitContentLyrics;
  int? explicitContentCover;
  List<Contributors>? contributors;
  Artist? artist;
  String? type;

  Album(
      {this.id,
      this.title,
      this.upc,
      this.link,
      this.share,
      this.cover,
      this.coverSmall,
      this.coverMedium,
      this.coverBig,
      this.coverXl,
      this.md5Image,
      this.genreId,
      this.genres,
      this.label,
      this.nbTracks,
      this.duration,
      this.fans,
      this.releaseDate,
      this.recordType,
      this.available,
      this.tracklist,
      this.explicitLyrics,
      this.explicitContentLyrics,
      this.explicitContentCover,
      this.contributors,
      this.artist,
      this.type});

  Album.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    upc = json["upc"];
    link = json["link"];
    share = json["share"];
    cover = json["cover"];
    coverSmall = json["cover_small"];
    coverMedium = json["cover_medium"];
    coverBig = json["cover_big"];
    coverXl = json["cover_xl"];
    md5Image = json["md5_image"];
    genreId = json["genre_id"];
    genres = json["genres"] == null ? null : Genres.fromJson(json["genres"]);
    label = json["label"];
    nbTracks = json["nb_tracks"];
    duration = json["duration"];
    fans = json["fans"];
    releaseDate = json["release_date"];
    recordType = json["record_type"];
    available = json["available"];
    tracklist = json["tracklist"];
    explicitLyrics = json["explicit_lyrics"];
    explicitContentLyrics = json["explicit_content_lyrics"];
    explicitContentCover = json["explicit_content_cover"];
    contributors = json["contributors"] == null
        ? null
        : (json["contributors"] as List)
            .map((e) => Contributors.fromJson(e))
            .toList();
    artist = json["artist"] == null ? null : Artist.fromJson(json["artist"]);
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["upc"] = upc;
    data["link"] = link;
    data["share"] = share;
    data["cover"] = cover;
    data["cover_small"] = coverSmall;
    data["cover_medium"] = coverMedium;
    data["cover_big"] = coverBig;
    data["cover_xl"] = coverXl;
    data["md5_image"] = md5Image;
    data["genre_id"] = genreId;
    data["label"] = label;
    data["nb_tracks"] = nbTracks;
    data["duration"] = duration;
    data["fans"] = fans;
    data["release_date"] = releaseDate;
    data["record_type"] = recordType;
    data["available"] = available;
    data["explicit_lyrics"] = explicitLyrics;
    data["explicit_content_lyrics"] = explicitContentLyrics;
    data["explicit_content_cover"] = explicitContentCover;
    data["type"] = type;
    return data;
  }

}

class Contributors {
  int? id;
  String? name;
  String? link;
  String? share;
  String? picture;
  String? pictureSmall;
  String? pictureMedium;
  String? pictureBig;
  String? pictureXl;
  bool? radio;
  String? tracklist;
  String? type;
  String? role;

  Contributors(
      {this.id,
      this.name,
      this.link,
      this.share,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.radio,
      this.tracklist,
      this.type,
      this.role});

  Contributors.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    link = json["link"];
    share = json["share"];
    picture = json["picture"];
    pictureSmall = json["picture_small"];
    pictureMedium = json["picture_medium"];
    pictureBig = json["picture_big"];
    pictureXl = json["picture_xl"];
    radio = json["radio"];
    tracklist = json["tracklist"];
    type = json["type"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["link"] = link;
    data["share"] = share;
    data["picture"] = picture;
    data["picture_small"] = pictureSmall;
    data["picture_medium"] = pictureMedium;
    data["picture_big"] = pictureBig;
    data["picture_xl"] = pictureXl;
    data["radio"] = radio;
    data["tracklist"] = tracklist;
    data["type"] = type;
    data["role"] = role;
    return data;
  }
}

class Genres {
  List<Data>? data;

  Genres({this.data});

  Genres.fromJson(Map<String, dynamic> json) {
    data = json["data"] == null
        ? null
        : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
  }

}

class Data {
  int? id;
  String? name;
  String? picture;
  String? type;

  Data({this.id, this.name, this.picture, this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    picture = json["picture"];
    type = json["type"];
  }

}
