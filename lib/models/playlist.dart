class Playlist {
  int? id;
  String? title;
  String? description;
  int? duration;
  bool? public;
  bool? isLovedTrack;
  bool? collaborative;
  int? nbTracks;
  int? fans;
  String? link;
  String? share;
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
  Creator? creator;
  UserPlaylist? user;
  String? type;

  Playlist(
      {this.id,
      this.title,
      this.description,
      this.duration,
      this.public,
      this.isLovedTrack,
      this.collaborative,
      this.nbTracks,
      this.fans,
      this.link,
      this.share,
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
      this.creator,
      this.user,
      this.type
      });

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    duration = json["duration"];
    public = json["public"];
    isLovedTrack = json["is_loved_track"];
    collaborative = json["collaborative"];
    nbTracks = json["nb_tracks"];
    fans = json["fans"];
    link = json["link"];
    share = json["share"];
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
    creator = json["creator"] == null ? null : Creator.fromJson(json["creator"]);
    user = json["user"] == null ? null : UserPlaylist.fromJson(json["user"]);
    type = json["type"];
  }

}

class UserPlaylist {
  int? id;
  String? name;
  String? tracklist;
  String? type;

  UserPlaylist({this.id, this.name, this.tracklist, this.type});

  UserPlaylist.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    tracklist = json["tracklist"];
    type = json["type"];
  }
}
class Creator {
  int? id;
  String? name;
  String? tracklist;
  String? type;

  Creator({this.id, this.name, this.tracklist, this.type});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    tracklist = json["tracklist"];
    type = json["type"];
  }
}