import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/view_models/track_play/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/views/play_control/play_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/default_constant.dart';
import '../../models/track.dart';
import '../../repository/remote/firebase/favorite_song_repository.dart';
import '../../widgets/action/action_more.dart';

class TrackPlay extends StatefulWidget {
  const TrackPlay({Key? key}) : super(key: key);

  @override
  State<TrackPlay> createState() => _TrackPlayState();
}

class _TrackPlayState extends State<TrackPlay> {
  double _dragDistance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MultiPlayerViewModel>(builder: (context, value, child) {
        return GestureDetector(
          onVerticalDragDown: (details) {
            _dragDistance = 0;
          },
          onVerticalDragUpdate: (details) {
            _dragDistance += details.delta.dy.abs();
          },
          onVerticalDragEnd: (details) {
            if (_dragDistance > 100) {
              Navigator.pop(context);
            }
          },
          child: Stack(
            children: [
              buildImageBackground(context, value),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black45,
              ),
              StreamBuilder<SequenceState?>(
                stream: value.player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const Icon(Ionicons.heart_outline);
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  Track track = value.currentTracks.firstWhere(
                      (element) => element.id == int.parse(metadata.id),
                      orElse: () => Track());
                  if (track.album != null) {
                    return Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: PlayControl(
                          track: track,
                          album: track.album!,
                        ));
                  } else {
                    return Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: PlayControl(
                          track: track,
                          album: value.getAlbum,
                        ));
                  }
                },
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  top: 20,
                  child: buildHeader(context, value)),
            ],
          ),
        );
      }),
    );
  }

  Widget buildHeader(BuildContext context, MultiPlayerViewModel value) {
    return StreamBuilder<SequenceState?>(
      stream: value.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;

        String? image;
        if (metadata.artist != null) {
          var value = metadata.artHeaders!['artArtist'];
          image = value.toString();
        } else {
          image = value.getAlbum.artist!.pictureSmall as String;
        }
        Track track = value.currentTracks.firstWhere(
            (element) => element.id == int.parse(metadata.id),
            orElse: () => Track());
        return Column(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                IconlyLight.arrowDown2,
                size: 40,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius / 2)),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/music_default.jpg',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metadata.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          metadata.artist.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: FavoriteSongRepository.instance.getFavoriteSongs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(0)),
                            onPressed: () {},
                            child: const Icon(Icons.more_vert),
                          ),
                        );
                      }
                      if (value.getAlbum.id != null) {
                        track.artist = value.getArtist;
                        track.album = value.getAlbum;
                        return ActionMore(
                          track: track,
                          album: value.getAlbum,
                        );
                      }
                      return ActionMore(
                        track: track,
                        album: track.album,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildImageBackground(
      BuildContext context, MultiPlayerViewModel value) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;

    return StreamBuilder<SequenceState?>(
      stream: value.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height,
              width: width,
              child: CachedNetworkImage(
                imageUrl: metadata.artUri.toString(),
                placeholder: (context, url) => Image.asset(
                  'assets/images/music_default.jpg',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            )
          ],
        );
      },
    );
  }
}
