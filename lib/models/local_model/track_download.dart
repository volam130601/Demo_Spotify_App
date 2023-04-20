class TrackDownload {
  int? id;
  String? trackId;
  String? taskId;
  String? title;
  String? artistName;
  String? artistPictureSmall;
  String? coverSmall;
  String? coverXl;
  String? preview;
  String? type;

  TrackDownload(
      {this.id,
      this.trackId,
      this.taskId,
      this.title,
      this.artistName,
      this.artistPictureSmall,
      this.coverSmall,
      this.coverXl,
      this.preview,
      this.type,
      });

  TrackDownload.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    trackId = data['track_id'];
    taskId = data['task_id'];
    title = data['title'];
    artistName = data['artist_name'];
    artistPictureSmall = data['artist_picture_small'];
    coverSmall = data['cover_small'];
    coverXl = data['cover_xl'];
    preview = data['preview'];
    type = data['type'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['track_id'] = trackId;
    data['task_id'] = taskId;
    data['title'] = title;
    data['artist_name'] = artistName;
    data['artist_picture_small'] = artistPictureSmall;
    data['cover_small'] = coverSmall;
    data['cover_xl'] = coverXl;
    data['preview'] = preview;
    data['type'] = type;
    return data;
  }
}
