class AlbumDownload {
  int? id;
  String? title;
  String? artistName;
  String? pictureSmall;
  String? releaseDate;
  String? coverXl;
  String? type;
  int? createTime;

  AlbumDownload({
    this.id,
    this.title,
    this.artistName,
    this.pictureSmall,
    this.coverXl,
    this.releaseDate,
    this.type,
    this.createTime,
  });

  AlbumDownload.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    artistName = data['artist_name'];
    pictureSmall = data['picture_small'];
    coverXl = data['cover_xl'];
    releaseDate = data['release_date'];
    type = data['type'];
    createTime = data['create_time'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['artist_name'] = artistName;
    data['picture_small'] = pictureSmall;
    data['cover_xl'] = coverXl;
    data['release_date'] = releaseDate;
    data['type'] = type;
    data['create_time'] =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();
    return data;
  }
}
