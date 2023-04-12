class GenreSearch {
  int? id;
  String? title;
  List<Radios>? radios;

  GenreSearch({this.id, this.title, this.radios});

  GenreSearch.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    radios = json["radios"] == null ? null : (json["radios"] as List).map((e) => Radios.fromJson(e)).toList();
  }
}

class Radios {
  int? id;
  String? title;
  String? picture;
  String? pictureSmall;
  String? pictureMedium;
  String? pictureBig;
  String? pictureXl;
  String? md5Image;
  String? type;

  Radios({this.id, this.title, this.picture, this.pictureSmall, this.pictureMedium, this.pictureBig, this.pictureXl, this.md5Image, this.type});

  Radios.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    picture = json["picture"];
    pictureSmall = json["picture_small"];
    pictureMedium = json["picture_medium"];
    pictureBig = json["picture_big"];
    pictureXl = json["picture_xl"];
    md5Image = json["md5_image"];
    type = json["type"];
  }
}