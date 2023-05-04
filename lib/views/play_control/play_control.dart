import 'package:demo_spotify_app/views/play_control/comment_box.dart';
import 'package:demo_spotify_app/widgets/navigator/slide_animation_page_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/default_constant.dart';
import '../../../view_models/multi_control_player_view_model.dart';
import '../../../widgets/play_control/seekbar.dart';
import 'control_music_buttons.dart';

class PlayControl extends StatelessWidget {
  const PlayControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiPlayerViewModel>(
      builder: (context, provider, _) {
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
              stream: provider.positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: provider.player.seek,
                );
              },
            ),
            ControlMusicButtons(player: provider.player),
            paddingHeight(1.5),
            buildListMoreActions(context)
          ],
        );
      },
    );
  }

  Padding buildListMoreActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, SlideTopPageRoute(page: const CommentBoxScreen()));
              },
              style: IconButton.styleFrom(
                  elevation: 0, padding: const EdgeInsets.all(0)),
              icon:
                  Icon(Ionicons.chatbox_outline, color: Colors.grey.shade300)),
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
