import 'package:demo_spotify_app/models/firebase/recent_search.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/network/firebase/recent_search_service.dart';
import '../../../models/album.dart';
import '../../../models/artist.dart';
import '../../../models/playlist.dart';
import '../../../models/track.dart';

class RecentSearchRepository {
  RecentSearchRepository._();

  static final RecentSearchRepository instance = RecentSearchRepository._();
  final _recentSearchService = RecentSearchService();

  Future<void> addRecentSearchTrack(Track track) async {
    Album album = track.album!;
    Artist artist = track.artist!;
    RecentSearchItem recentSearchItem = RecentSearchItem(
        id: DateTime.now().toString(),
        itemId: '${track.id}',
        title: '${track.title}',
        image: '${track.album!.coverSmall}',
        albumSearch: AlbumSearch(
            id: album.id, title: album.title, coverXl: album.coverXl),
        artistSearch: ArtistSearch(
            id: artist.id,
            name: artist.name,
            pictureSmall: artist.pictureSmall),
        type: '${track.type}',
        userId: FirebaseAuth.instance.currentUser!.uid);
    await _recentSearchService.addRecentSearch(recentSearchItem);
  }

  Future<void> addRecentSearchArtist(Artist artist) async {
    RecentSearchItem recentSearchItem = RecentSearchItem(
      id: DateTime.now().toString(),
      itemId: '${artist.id}',
      title: '${artist.name}',
      image: '${artist.pictureSmall}',
      type: '${artist.type}',
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _recentSearchService.addRecentSearch(recentSearchItem);
  }

  Future<void> addRecentSearchPlaylist(Playlist playlist) async {
    RecentSearchItem recentSearchItem = RecentSearchItem(
        id: DateTime.now().toString(),
        itemId: '${playlist.id}',
        title: '${playlist.title}',
        image: '${playlist.pictureSmall}',
        type: '${playlist.type}',
        userId: FirebaseAuth.instance.currentUser!.uid,
        playlistSearch: PlaylistSearch(
            id: playlist.id,
            title: playlist.title,
            pictureSmall: playlist.pictureSmall,
            pictureMedium: playlist.pictureMedium,
            pictureXl: playlist.pictureXl,
            userName: playlist.user!.name));
    await _recentSearchService.addRecentSearch(recentSearchItem);
  }

  Future<void> addRecentSearchAlbum(Album album) async {
    Artist? artist = album.artist;
    RecentSearchItem recentSearchItem = RecentSearchItem(
      id: DateTime.now().toString(),
      itemId: '${album.id}',
      title: '${album.title}',
      image: '${album.coverSmall}',
      type: '${album.type}',
      userId: FirebaseAuth.instance.currentUser!.uid,
      albumSearch:
          AlbumSearch(id: album.id, title: album.title, coverXl: album.coverXl),
      artistSearch: ArtistSearch(
          id: artist!.id,
          name: artist.name,
          pictureSmall: artist.pictureSmall,
          pictureXl: artist.pictureXl),
    );
    await _recentSearchService.addRecentSearch(recentSearchItem);
  }

  Future<bool> isCheckExists(int itemId, String userId) async {
    return await _recentSearchService.isCheckExists(itemId, userId);
  }

  Stream<List<RecentSearchItem>> getItemsByUserId(String userId) {
    return _recentSearchService.getItemsByUserId(userId);
  }

  Future<void> deleteRecentSearch(String id) {
    return _recentSearchService.deleteRecentSearch(id);
  }

  Future<void> deleteAll() {
    return _recentSearchService.deleteAll();
  }
}
