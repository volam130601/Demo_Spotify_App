import 'package:demo_spotify_app/views/play_control/comment_box.dart';
import 'package:demo_spotify_app/widgets/navigator/slide_animation_page_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/default_constant.dart';
import '../../view_models/track_play/multi_control_player_view_model.dart';
import '../../../widgets/play_control/seekbar.dart';
import 'control_music_buttons.dart';

class PlayControl extends StatelessWidget {
  const PlayControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiPlayerViewModel>(
      builder: (context, value, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                          elevation: 0, padding: const EdgeInsets.all(0)),
                      icon: Icon(
                        Ionicons.share_social_outline,
                        color: Colors.grey.shade300,
                      )),
                  const Spacer(),
                  IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                          elevation: 0, padding: const EdgeInsets.all(0)),
                      icon: Icon(Ionicons.heart_outline,
                          color: Colors.grey.shade300)),
                ],
              ),
            ),
            StreamBuilder<PositionData>(
              stream: value.positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: value.player.seek,
                );
              },
            ),
            ControlMusicButtons(player: value.player),
            paddingHeight(1.5),
            buildListMoreActions(context, value),
          ],
        );
      },
    );
  }

  Padding buildListMoreActions(
      BuildContext context, MultiPlayerViewModel value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<SequenceState?>(
            stream: value.player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const Icon(Ionicons.chatbox_outline);
              }
              final metadata = state!.currentSource!.tag as MediaItem;
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    SlideTopPageRoute(
                      page: CommentBoxScreen(
                        trackId: metadata.id,
                      ),
                    ),
                  );
                },
                style: IconButton.styleFrom(
                    elevation: 0, padding: const EdgeInsets.all(0)),
                icon:
                    Icon(Ionicons.chatbox_outline, color: Colors.grey.shade300),
              );
            },
          ),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
                elevation: 0, padding: const EdgeInsets.all(0)),
            icon: Image.asset(
              'assets/icons/icons8-add-song-48.png',
              color: Colors.grey.shade300,
              width: 25,
              height: 25,
            ),
          ),
          IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                  elevation: 0, padding: const EdgeInsets.all(0)),
              icon: Icon(Ionicons.arrow_down_circle_outline,
                  color: Colors.grey.shade300)),
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
                elevation: 0, padding: const EdgeInsets.all(0)),
            icon: Image.asset(
              'assets/icons/icons8-disk-24.png',
              color: Colors.grey.shade300,
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }
}
