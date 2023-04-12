class Genre {
  int? id;
  String? title;
  String? picture;
  String? pictureSmall;
  String? pictureMedium;
  String? pictureBig;
  String? pictureXl;
  String? tracklist;
  String? md5Image;
  String? type;

  Genre({this.id, this.title, this.picture, this.pictureSmall, this.pictureMedium, this.pictureBig, this.pictureXl, this.tracklist, this.md5Image, this.type});

  Genre.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    picture = json["picture"];
    pictureSmall = json["picture_small"];
    pictureMedium = json["picture_medium"];
    pictureBig = json["picture_big"];
    pictureXl = json["picture_xl"];
    tracklist = json["tracklist"];
    md5Image = json["md5_image"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["picture"] = picture;
    data["picture_small"] = pictureSmall;
    data["picture_medium"] = pictureMedium;
    data["picture_big"] = pictureBig;
    data["picture_xl"] = pictureXl;
    data["tracklist"] = tracklist;
    data["md5_image"] = md5Image;
    data["type"] = type;
    return data;
  }
}