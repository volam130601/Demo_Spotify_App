class PlaylistDownload {
  int? id;
  String? title;
  String? pictureMedium;
  String? pictureXl;
  String? userName;
  String? type;
  int? createTime;

  PlaylistDownload({
    this.id,
    this.title,
    this.pictureMedium,
    this.pictureXl,
    this.userName,
    this.type,
    this.createTime,
  });

  PlaylistDownload.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    pictureMedium = data['picture_medium'];
    pictureXl = data['picture_xl'];
    userName = data['user_name'];
    type = data['type'];
    createTime = data['create_time'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['picture_medium'] = pictureMedium;
    data['picture_xl'] = pictureXl;
    data['user_name'] = userName;
    data['type'] = type;
    data['create_time'] =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();
    return data;
  }
}
