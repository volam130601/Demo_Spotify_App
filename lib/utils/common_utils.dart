import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/album.dart';
import '../models/artist.dart';
import '../models/track.dart';

class CommonUtils {
  static List<Track> convertTrackDownloadsToTracks(
          List<TrackDownload> trackDownloads) =>
      trackDownloads
          .map((track) => Track(
              id: track.id,
              title: track.title,
              album:
                  Album(coverSmall: track.coverSmall, coverXl: track.coverXl),
              artist: Artist(
                  name: track.artistName,
                  pictureMedium: track.artistPictureSmall),
              preview: track.preview,
              duration: track.duration,
              type: track.type))
          .toList();

  static String convertTotalDuration(List<Track> tracks) {
    int totalDuration = tracks.fold(0, (sum, item) => sum + item.duration!);
    int seconds = totalDuration;
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}min';
  }

  static String totalDuration(int duration) {
    int minutes = duration ~/ 60;
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}min';
  }

  static String subStringTrackId(String str) {
    int lastIndexOfDash = str.lastIndexOf('-');
    return str.substring(lastIndexOfDash + 1, str.length - 4);
  }

  static int subStringPlaylistId(String str) {
    if (str.contains('playlist')) {
      final int startIndex = str.indexOf('-') + 1;
      final int endIndex = str.lastIndexOf('-');
      final String result = str.substring(startIndex, endIndex);
      return int.parse(result);
    }
    return 0;
  }

  static String formatReleaseDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    return DateFormat('MMMM d, y').format(dateTime);
  }

  static String getYearByReleaseDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    return dateTime.year.toString();
  }

  ///getFileSize
  static Future<int> getFileSize(String text) async {
    var url = Uri.parse(text);
    http.Response response = await http.head(url);
    int? contentLength = int.tryParse(response.headers['content-length'] ?? '');
    return contentLength ?? 0;
  }

  static String formatSize(int sizeInBytes) {
    double sizeInMB = sizeInBytes / (1024 * 1024);
    String size = sizeInMB.toStringAsFixed(1);
    return '$size MB';
  }

  static Future<int> getSizeInBytesOfTrackDownload(
      List<Track> tracks) async {
    int totalSize = 0;
    for (var track in tracks) {
      if(track.preview != '') {
        totalSize += await getFileSize(track.preview.toString());
      }
    }
    return totalSize;
  }

  static String convertToShorthand(int num) {
    String shorthand;
    if (num >= 1000000) {
      shorthand = '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      shorthand = '${(num / 1000).toStringAsFixed(1)}K';
    } else {
      shorthand = num.toString();
    }
    return shorthand;
  }
}
