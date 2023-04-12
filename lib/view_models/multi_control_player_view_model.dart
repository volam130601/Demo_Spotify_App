import 'dart:developer';

import 'package:demo_spotify_app/models/artist.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../models/album.dart';
import '../models/track.dart';
import '../widgets/play_control/common.dart';

class MultiPlayerViewModel with ChangeNotifier {
  dynamic _playlist = ConcatenatingAudioSource(children: []);
  final AudioPlayer _player = AudioPlayer();
  bool isCheckPlayer = false;
  int _playlistId = 0;
  int _albumId = 0;
  int _artistId = 0;
  Album _album = Album();
  Artist _artist = Artist();

  int get getPlaylistId => _playlistId;
  int get getAlbumId => _albumId;
  int get getArtistId => _artistId;
  Album get getAlbum => _album;
  Artist get getArtist => _artist;
  AudioPlayer get player => _player;

  Future<void> initState(
      {required List<Track> tracks,
      int? playlistId,
      int? albumId,
      int? artistId,
      int? index,
      Album? album,
      Artist? artist,
      }) async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
    try {
      _playlistId = playlistId ?? 0;
      _albumId = albumId ?? 0;
      _artistId = artistId ?? 0;
      _album = album ?? Album();
      _artist = artist ?? Artist();

      addTracks(tracks);
      await _player.setAudioSource(_playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);

      if (index != null) {
        player.seek(Duration.zero, index: index);
      }

      notifyListeners();
    } catch (e) {
      // Catch load errors: 404, invalid url...
      log("Error loading audio source: $e");
    }
  }

  void addTracks(List<Track> tracks) {
    List<AudioSource> audioSources = <AudioSource>[];

    for (var track in tracks) {
      audioSources.add(AudioSource.uri(
        Uri.parse(track.preview as String),
        tag: MediaItem(
          id: track.id.toString(),
          title: track.title as String,
          album: track.album?.title,
          artist: track.artist?.name,
          artHeaders: {
            "artArtist": (_artist.id != null) ? "${_artist.pictureSmall}" :"${track.artist?.pictureSmall}"
          },
          artUri: Uri.parse(track.album?.coverXl as String),
        ),
      ));
    }
    _playlist = ConcatenatingAudioSource(children: audioSources);
    isCheckPlayer = true;
  }

  void clearPlaylist() {
    _playlist = ConcatenatingAudioSource(children: []);
    isCheckPlayer = false;
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}
