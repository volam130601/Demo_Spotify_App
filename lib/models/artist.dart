class Artist {
  int? id;
  String? name;
  String? link;
  String? share;
  String? picture;
  String? pictureSmall;
  String? pictureMedium;
  String? pictureBig;
  String? pictureXl;
  int? nbAlbum;
  int? nbFan;
  bool? radio;
  String? tracklist;
  String? type;

  Artist(
      {this.id,
      this.name,
      this.link,
      this.share,
      this.picture,
      this.pictureSmall,
      this.pictureMedium,
      this.pictureBig,
      this.pictureXl,
      this.nbAlbum,
      this.nbFan,
      this.radio,
      this.tracklist,
      this.type});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    link = json["link"];
    share = json["share"];
    picture = json["picture"];
    pictureSmall = json["picture_small"];
    pictureMedium = json["picture_medium"];
    pictureBig = json["picture_big"];
    pictureXl = json["picture_xl"];
    nbAlbum = json["nb_album"];
    nbFan = json["nb_fan"];
    radio = json["radio"];
    tracklist = json["tracklist"];
    type = json["type"];
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
    data["nb_album"] = nbAlbum;
    data["nb_fan"] = nbFan;
    data["radio"] = radio;
    data["tracklist"] = tracklist;
    data["type"] = type;
    return data;
  }
}
