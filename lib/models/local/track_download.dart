class TrackDownload {
  int? id;
  int? playlistId;
  int? albumId;
  String? taskId;
  String? title;
  String? artistName;
  String? artistPictureSmall;
  String? coverSmall;
  String? coverXl;
  String? preview;
  int? duration;
  String? type;
  int? createTime;

  TrackDownload({
    this.id,
    this.playlistId,
    this.albumId,
    this.taskId,
    this.title,
    this.artistName,
    this.artistPictureSmall,
    this.coverSmall,
    this.coverXl,
    this.preview,
    this.duration,
    this.type,
    this.createTime,
  });

  TrackDownload.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    playlistId = data['playlist_id'];
    albumId = data['album_id'];
    taskId = data['task_id'];
    title = data['title'];
    artistName = data['artist_name'];
    artistPictureSmall = data['artist_picture_small'];
    coverSmall = data['cover_small'];
    coverXl = data['cover_xl'];
    preview = data['preview'];
    duration = data['duration'];
    type = data['type'];
    createTime = data['create_time'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['playlist_id'] = playlistId;
    data['album_id'] = albumId;
    data['task_id'] = taskId;
    data['title'] = title;
    data['artist_name'] = artistName;
    data['artist_picture_small'] = artistPictureSmall;
    data['cover_small'] = coverSmall;
    data['cover_xl'] = coverXl;
    data['preview'] = preview;
    data['duration'] = duration;
    data['type'] = type;
    data['create_time'] =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();
    return data;
  }
}
