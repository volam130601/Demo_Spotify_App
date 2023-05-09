import '../../../data/network/firebase/playlist_new_service.dart';
import '../../../models/firebase/playlist_new.dart';
import '../../../models/track.dart';

class PlaylistNewRepository {
  PlaylistNewRepository._();

  static final PlaylistNewRepository instance = PlaylistNewRepository._();
  final _playlistNewService = PlaylistNewService();

  Future<void> addPlaylistNew(PlaylistNew playlistNew) async {
    await _playlistNewService.addPlaylistNew(playlistNew);
  }

  Future<void> addTrackToPlaylistNew(
      {required PlaylistNew playlistNew, required Track track}) async {
    List<Track> tracks = playlistNew.tracks!;
    final bool isExist = tracks.any((element) => element.id == track.id);
    if (!isExist) {
      tracks.add(track);
      await _playlistNewService.updatePlaylistNew(PlaylistNew(
        id: playlistNew.id,
        title: playlistNew.title,
        isDownloading: playlistNew.isDownloading,
        isPrivate: playlistNew.isDownloading,
        picture: tracks.first.album!.coverMedium,
        releaseDate: playlistNew.releaseDate,
        userId: playlistNew.userId,
        tracks: tracks,
        userName: playlistNew.userName,
      ));
    }
  }

  Future<void> removePlaylistNewByTrackId(
      {required PlaylistNew playlistNew, required int trackId}) async {
    List<Track> tracks = playlistNew.tracks!;
    tracks.removeWhere((element) => element.id == trackId);
    await _playlistNewService.updatePlaylistNew(PlaylistNew(
      id: playlistNew.id,
      title: playlistNew.title,
      isDownloading: playlistNew.isDownloading,
      isPrivate: playlistNew.isDownloading,
      picture: (tracks.isNotEmpty) ? tracks.first.album!.coverBig : null,
      releaseDate: playlistNew.releaseDate,
      userId: playlistNew.userId,
      tracks: tracks,
      userName: playlistNew.userName,
    ));
  }

  Future<void> deletePlaylistNew(String id) async {
    await _playlistNewService.deletePlaylistNew(id);
  }

  Future<void> deleteAll() async {
    await _playlistNewService.deleteAll();
  }

  Stream<List<PlaylistNew>> getPlaylistNews() {
    return _playlistNewService.getPlaylistNews();
  }

  Stream<List<Track>> getPlaylistNewByPlaylistId(String playlistId) {
    return _playlistNewService.getPlaylistNewByPlaylistId(playlistId);
  }
}
