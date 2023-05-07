import 'album.dart';
import 'artist.dart';

class Track {
  int? id;
  bool? readable;
  String? title;
  String? titleShort;
  String? titleVersion;
  String? isrc;
  String? link;
  String? share;
  int? duration;
  int? trackPosition;
  int? diskNumber;
  int? rank;
  String? releaseDate;
  bool? explicitLyrics;
  int? explicitContentLyrics;
  int? explicitContentCover;
  String? preview;
  List<String>? availableCountries;
  List<Contributors>? contributors;
  String? md5Image;
  Artist? artist;
  Album? album;
  String? type;
  bool? isDownload;

  Track(
      {this.id,
      this.readable,
      this.title,
      this.titleShort,
      this.titleVersion,
      this.isrc,
      this.link,
      this.share,
      this.duration,
      this.trackPosition,
      this.diskNumber,
      this.rank,
      this.releaseDate,
      this.explicitLyrics,
      this.explicitContentLyrics,
      this.explicitContentCover,
      this.preview,
      this.availableCountries,
      this.contributors,
      this.md5Image,
      this.artist,
      this.album,
      this.type,
      this.isDownload
      });



  Track.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    readable = json["readable"];
    title = json["title"];
    titleShort = json["title_short"];
    titleVersion = json["title_version"];
    isrc = json["isrc"];
    link = json["link"];
    share = json["share"];
    duration = json["duration"];
    trackPosition = json["track_position"];
    diskNumber = json["disk_number"];
    rank = json["rank"];
    releaseDate = json["release_date"];
    explicitLyrics = json["explicit_lyrics"];
    explicitContentLyrics = json["explicit_content_lyrics"];
    explicitContentCover = json["explicit_content_cover"];
    preview = json["preview"];
    availableCountries = json["available_countries"] == null
        ? null
        : List<String>.from(json["available_countries"]);
    contributors = json["contributors"] == null
        ? null
        : (json["contributors"] as List)
            .map((e) => Contributors.fromJson(e))
            .toList();
    md5Image = json["md5_image"];
    artist = json["artist"] == null ? null : Artist.fromJson(json["artist"]);
    album = json["album"] == null ? null : Album.fromJson(json["album"]);
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["readable"] = readable;
    data["title"] = title;
    data["title_short"] = titleShort;
    data["title_version"] = titleVersion;
    data["isrc"] = isrc;
    data["link"] = link;
    data["share"] = share;
    data["duration"] = duration;
    data["track_position"] = trackPosition;
    data["disk_number"] = diskNumber;
    data["rank"] = rank;
    data["release_date"] = releaseDate;
    data["explicit_lyrics"] = explicitLyrics;
    data["explicit_content_lyrics"] = explicitContentLyrics;
    data["explicit_content_cover"] = explicitContentCover;
    data["preview"] = preview;
    if (availableCountries != null) {
      data["available_countries"] = availableCountries;
    }
    if (contributors != null) {
      data["contributors"] = contributors?.map((e) => e.toJson()).toList();
    }
    data["md5_image"] = md5Image;
    if (artist != null) {
      data["artist"] = artist?.toJson();
    }
    if (album != null) {
      data["album"] = album?.toJson();
    }
    data["type"] = type;
    return data;
  }
}
