import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/view_models/track_play/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/views/play_control/track_play.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/default_constant.dart';
import '../../widgets/navigator/slide_animation_page_route.dart';
import '../../widgets/play_control/seekbar.dart';

class PLayTrackCard extends StatelessWidget {
  const PLayTrackCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiPlayerViewModel>(
      builder: (context, value, child) {
        if (value.isCheckPlayer) {
          return InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(SlideTopPageRoute(page: const TrackPlay()));
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(defaultBorderRadius / 2)),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Stack(
                children: [
                  StreamBuilder<SequenceState?>(
                    stream: value.player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) {
                        return const SizedBox();
                      }
                      final metadata = state!.currentSource!.tag as MediaItem;

                      return Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  defaultBorderRadius / 2),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: metadata.artUri.toString(),
                              placeholder: (context, url) => Image.asset(
                                'assets/images/music_default.jpg',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: defaultPadding / 2),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  metadata.title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  metadata.artist.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<SequenceState?>(
                            stream: value.player.sequenceStateStream,
                            builder: (context, snapshot) => IconButton(
                              icon: const Icon(Ionicons.play_skip_forward),
                              style: IconButton.styleFrom(
                                  elevation: 0, padding: const EdgeInsets.all(0)),
                              onPressed: value.player.hasNext ? value.player.seekToNext : null,
                            ),
                          ),
                          StreamBuilder<PlayerState>(
                            stream: value.player.playerStateStream,
                            builder: (context, snapshot) {
                              final playerState = snapshot.data;
                              final processingState =
                                  playerState?.processingState;
                              final playing = playerState?.playing;
                              if (processingState == ProcessingState.loading ||
                                  processingState ==
                                      ProcessingState.buffering) {
                                return Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                );
                              } else if (playing != true) {
                                return IconButton(
                                  onPressed: value.player.play,
                                  icon: const Icon(Icons.play_arrow, size: 32),
                                );
                              } else if (processingState !=
                                  ProcessingState.completed) {
                                return IconButton(
                                  onPressed: value.player.pause,
                                  icon: const Icon(Ionicons.pause, size: 32),
                                );
                              } else {
                                return IconButton(
                                  onPressed: () =>
                                      value.player.seek(Duration.zero),
                                  icon: const Icon(Icons.replay, size: 32),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  Positioned(
                    bottom: 2,
                    left: 0,
                    right: 0,
                    child: StreamBuilder<PositionData>(
                      stream: value.positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return SeekBar(
                          duration: positionData?.duration ?? Duration.zero,
                          position: positionData?.position ?? Duration.zero,
                          bufferedPosition:
                              positionData?.bufferedPosition ?? Duration.zero,
                          onChangeEnd: value.player.seek,
                          isShow: false,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
