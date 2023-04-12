class Playlist {
  int? id;
  String? title;
  bool? public;
  int? nbTracks;
  String? link;
  String? picture;
  String? pictureSmall;
  String? pictureMedium;
  String? pictureBig;
  String? pictureXl;
  String? checksum;
  String? tracklist;
  String? creationDate;
  String? md5Image;
  String? pictureType;
  User? user;
  String? type;

  Playlist(
      {this.id,
      this.title,
      this.public,
      this.nbTracks,
      this.link,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.checksum,
      this.tracklist,
      this.creationDate,
      this.md5Image,
      this.pictureType,
      this.user,
      this.type});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    public = json["public"];
    nbTracks = json["nb_tracks"];
    link = json["link"];
    picture = json["picture"];
    pictureSmall = json["picture_small"];
    pictureMedium = json["picture_medium"];
    pictureBig = json["picture_big"];
    pictureXl = json["picture_xl"];
    checksum = json["checksum"];
    tracklist = json["tracklist"];
    creationDate = json["creation_date"];
    md5Image = json["md5_image"];
    pictureType = json["picture_type"];
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["public"] = public;
    data["nb_tracks"] = nbTracks;
    data["link"] = link;
    data["picture"] = picture;
    data["picture_small"] = pictureSmall;
    data["picture_medium"] = pictureMedium;
    data["picture_big"] = pictureBig;
    data["picture_xl"] = pictureXl;
    data["checksum"] = checksum;
    data["tracklist"] = tracklist;
    data["creation_date"] = creationDate;
    data["md5_image"] = md5Image;
    data["picture_type"] = pictureType;
    if (user != null) {
      data["user"] = user?.toJson();
    }
    data["type"] = type;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? tracklist;
  String? type;

  User({this.id, this.name, this.tracklist, this.type});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    tracklist = json["tracklist"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["tracklist"] = tracklist;
    data["type"] = type;
    return data;
  }
}
