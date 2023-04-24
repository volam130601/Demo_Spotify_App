class PlaylistDownload {
  int? id;
  String? playlistId;
  String? title;
  String? pictureMedium;
  String? pictureXl;
  String? userName;
  String? type;

  PlaylistDownload(
      {this.id,
      this.playlistId,
      this.title,
      this.pictureMedium,
      this.pictureXl,
      this.userName,
      this.type});

  PlaylistDownload.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    playlistId = data['playlist_id'];
    title = data['title'];
    pictureMedium = data['picture_medium'];
    pictureXl = data['picture_xl'];
    userName = data['user_name'];
    type = data['type'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['playlist_id'] = playlistId;
    data['title'] = title;
    data['picture_medium'] = pictureMedium;
    data['picture_xl'] = pictureXl;
    data['user_name'] = userName;
    data['type'] = type;
    return data;
  }
}
