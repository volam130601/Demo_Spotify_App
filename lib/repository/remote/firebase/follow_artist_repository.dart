import 'package:demo_spotify_app/data/network/firebase/follow_artist_service.dart';
import 'package:demo_spotify_app/models/firebase/follow_artist.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/artist.dart';

class FollowArtistRepository {
  FollowArtistRepository._();

  static final FollowArtistRepository instance = FollowArtistRepository._();
  final _followArtistService = FollowArtistService();

  Future<void> addFollowArtist({required List<Artist> artists}) async {
    await _followArtistService.addFollowArtist(FollowArtist(
      userId: FirebaseAuth.instance.currentUser!.uid,
      artists: artists,
    ));
  }

  Future<void> addMoreFollowArtist(
      {required FollowArtist followArtist,
      required List<Artist> artists}) async {
    followArtist.artists = artists;
    await _followArtistService.updateFollowArtist(followArtist);
  }

  Future<void> followingArtist(
      {required FollowArtist followArtist, required Artist artist}) async {
    followArtist.artists!.add(artist);
    await _followArtistService.updateFollowArtist(followArtist);
  }

  Future<void> unFollowingArtist(
      {required FollowArtist followArtist, required Artist artist}) async {
    followArtist.artists!.removeWhere((element) => element.id == artist.id);
    await _followArtistService.updateFollowArtist(followArtist);
  }

  Future<void> deleteFollowArtist(String id) async {
    await _followArtistService.deleteFollowArtist(id);
  }

  Future<void> deleteAll() async {
    await _followArtistService.deleteAll();
  }

  Stream<FollowArtist> getFollowArtist() {
    return _followArtistService.getFollowArtist();
  }
}
