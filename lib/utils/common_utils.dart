import 'package:demo_spotify_app/models/local/track_download.dart';

import '../models/album.dart';
import '../models/artist.dart';
import '../models/track.dart';

class CommonUtils {
  CommonUtils._();

  static final CommonUtils instance = CommonUtils._();

  List<Track> convertTrackDownloadsToTracks(
          List<TrackDownload> trackDownloads) =>
      trackDownloads
          .map((item) => Track(
              id: int.parse(item.trackId.toString()),
              title: item.title,
              album: Album(coverSmall: item.coverSmall, coverXl: item.coverXl),
              artist: Artist(
                  name: item.artistName, pictureSmall: item.artistPictureSmall),
              preview: item.preview,
              duration: item.duration,
              type: item.type))
          .toList();

  String convertTotalDuration(List<Track> tracks) {
    int totalDuration = 0;
    for (var item in tracks) {
      totalDuration += item.duration!;
    }
    int seconds = totalDuration;
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '$hours h $remainingMinutes min';
  }

   String subStringTrackId(String str) {
    int lastIndexOfDash = str.lastIndexOf('-');
    return str.substring(lastIndexOfDash + 1, str.length - 4);
  }
}
