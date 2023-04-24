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
          .map((track) => Track(
              id: track.id,
              title: track.title,
              album:
                  Album(coverSmall: track.coverSmall, coverXl: track.coverXl),
              artist: Artist(
                  name: track.artistName,
                  pictureSmall: track.artistPictureSmall),
              preview: track.preview,
              duration: track.duration,
              type: track.type))
          .toList();

  String convertTotalDuration(List<Track> tracks) {
    int totalDuration = tracks.fold(0, (sum, item) => sum + item.duration!);
    int seconds = totalDuration;
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}min';
  }

  String subStringTrackId(String str) {
    int lastIndexOfDash = str.lastIndexOf('-');
    return str.substring(lastIndexOfDash + 1, str.length - 4);
  }

  int subStringPlaylistId(String str) {
    if (str.contains('playlist')) {
      final int startIndex = str.indexOf('-') + 1;
      final int endIndex = str.lastIndexOf('-');
      final String result = str.substring(startIndex, endIndex);
      return int.parse(result);
    }
    return 0;
  }
}
