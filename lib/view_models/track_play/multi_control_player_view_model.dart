import 'dart:developer';

import 'package:demo_spotify_app/models/artist.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/album.dart';
import '../../models/track.dart';
import '../../widgets/play_control/seekbar.dart';

class MultiPlayerViewModel with ChangeNotifier {
  AudioPlayer _player = AudioPlayer();
  dynamic _playlist = ConcatenatingAudioSource(children: []);
  bool isCheckPlayer = false;
  int _playlistId = 0;
  int _albumId = 0;
  int _artistId = 0;
  Album _album = Album();
  Artist _artist = Artist();
  List<Track> currentTracks = [];
  int get getPlaylistId => _playlistId;

  int get getAlbumId => _albumId;

  int get getArtistId => _artistId;

  Album get getAlbum => _album;

  Artist get getArtist => _artist;

  AudioPlayer get player => _player;

  Future<void> initState({
    required List<Track> tracks,
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
      currentTracks = tracks;
      addTracks(tracks);
      await _player.setAudioSource(_playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);

      if (index != null) {
        player.seek(Duration.zero, index: index);
      }
      player.play();
      notifyListeners();
    } catch (e) {
      // Catch load errors: 404, invalid url...
      log("Error loading audio source: $e");
    }
  }

  void addTracks(List<Track> tracks) {
    List<AudioSource> audioSources = <AudioSource>[];

    for (var track in tracks) {
      if (track.type == 'track_local') {
        audioSources.add(AudioSource.file(
          '${track.preview}',
          tag: MediaItem(
            id: track.id.toString(),
            title: track.title as String,
            album: track.album!.title,
            artist: track.artist!.name,
            artHeaders: {
              "artArtist": (_artist.pictureMedium != null)
                  ? "${_artist.pictureMedium}"
                  : "${track.artist!.pictureMedium}",
            },
            artUri: (_album.coverXl != null)
                ? Uri.parse(_album.coverXl.toString())
                : Uri.parse(track.album!.coverXl.toString()),
          ),
        ));
      } else {
        audioSources.add(AudioSource.uri(
          Uri.parse(track.preview as String),
          tag: MediaItem(
            id: track.id.toString(),
            title: track.title as String,
            album: (_album.title != null) ? _album.title : track.album!.title,
            artist: track.artist!.name,
            artHeaders: {
              "artArtist": (_artist.pictureMedium != null)
                  ? "${_artist.pictureMedium}"
                  : "${track.artist!.pictureMedium}"
            },
            artUri: (_album.coverXl != null)
                ? Uri.parse(_album.coverXl.toString())
                : Uri.parse(track.album!.coverXl.toString()),
          ),
        ));
      }
    }
    _playlist = ConcatenatingAudioSource(children: audioSources);
    isCheckPlayer = true;
  }

  void clear() {
    _player.dispose();
    _player = AudioPlayer();
    _playlist = ConcatenatingAudioSource(children: []);
    isCheckPlayer = false;
    _playlistId = 0;
    _albumId = 0;
    _artistId = 0;
    _album = Album();
    _artist = Artist();
  }

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
}
