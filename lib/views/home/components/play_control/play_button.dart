import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/album.dart';
import '../../../../models/artist.dart';
import '../../../../models/track.dart';
import '../../../../res/constants/default_constant.dart';

class PlayButton extends StatefulWidget {
  const PlayButton(
      {Key? key,
      required this.tracks,
      this.playlistId,
      this.album,
      this.artist,
      this.albumId,
      this.artistId,
      })
      : super(key: key);
  final List<Track> tracks;
  final int? playlistId;
  final int? albumId;
  final int? artistId;
  final Album? album;
  final Artist? artist;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    double height = 45;
    double width = 45;
    var margin = const EdgeInsets.all(defaultPadding / 2);

    int? currentPlaylistId =
        Provider.of<MultiPlayerViewModel>(context, listen: true).getPlaylistId;

    int? currentAlbumId =
        Provider.of<MultiPlayerViewModel>(context, listen: true).getAlbumId;

    int? currentArtistId =
        Provider.of<MultiPlayerViewModel>(context, listen: true).getArtistId;

    if (widget.playlistId != currentPlaylistId && widget.playlistId != null) {
      return Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () {
            var value =
                Provider.of<MultiPlayerViewModel>(context, listen: false);
            value.initState(
                tracks: widget.tracks,
                playlistId: widget.playlistId as int,
                index: 0);
          },
          style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.all(0),
              shape: const CircleBorder()),
          child: const Icon(Icons.play_arrow, size: 32),
        ),
      );
    }

    if (widget.albumId != currentAlbumId && widget.albumId != null) {
      return Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () {
            var value =
                Provider.of<MultiPlayerViewModel>(context, listen: false);
            value.initState(
                tracks: widget.tracks,
                albumId: widget.albumId as int,
                album: widget.album,
                artist: widget.artist,
                index: 0);
          },
          style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.all(0),
              shape: const CircleBorder()),
          child: const Icon(Icons.play_arrow, size: 32),
        ),
      );
    }
    if (widget.artistId != currentArtistId && widget.artistId != null) {
      return Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () {
            var value =
                Provider.of<MultiPlayerViewModel>(context, listen: false);
            value.initState(
                tracks: widget.tracks,
                artistId: widget.artistId as int,
                artist: widget.artist,
                index: 0);
          },
          style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.all(0),
              shape: const CircleBorder()),
          child: const Icon(Icons.play_arrow, size: 32),
        ),
      );
    }

    return Consumer<MultiPlayerViewModel>(
      builder: (context, value, child) {
        return StreamBuilder<PlayerState>(
          stream: value.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;

            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: margin,
                width: width,
                height: height,
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              );
            } else if (playing != true) {
              return Container(
                margin: margin,
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: value.player.play,
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder()),
                  child: const Icon(Icons.play_arrow, size: 32),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return Container(
                margin: margin,
                width: width,
                height: height,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(defaultBorderRadius * 4)),
                child: ElevatedButton(
                  onPressed: value.player.pause,
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder()),
                  child: const Icon(Ionicons.pause, size: 32),
                ),
              );
            } else {
              return Container(
                margin: margin,
                width: width,
                height: height,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(defaultBorderRadius * 4)),
                child: ElevatedButton(
                  onPressed: () => value.player.seek(Duration.zero),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.all(0),
                      shape: const CircleBorder()),
                  child: const Icon(Icons.replay, size: 32),
                ),
              );
            }
          },
        );
      },
    );
  }
}
