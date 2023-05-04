import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../view_models/multi_control_player_view_model.dart';
import '../../../widgets/play_control/seekbar.dart';

class PlayControl extends StatefulWidget {
  const PlayControl({Key? key}) : super(key: key);

  @override
  PlayControlState createState() => PlayControlState();
}

class PlayControlState extends State<PlayControl> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

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
            buildListMoreActions()
          ],
        );
      },
    );
  }

  Padding buildListMoreActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                buildModalChatBox();
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

  Future<dynamic> buildModalChatBox() {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: defaultPadding, right: defaultPadding),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '1,1K comment',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const SizedBox(
                                width: 30, child: Icon(Icons.close))),
                      )
                    ],
                  ),
                ),
                const Divider(),
                paddingHeight(1),
                buildCommentBody(context)
              ],
            ),
          );
        },
      ),
    );
  }

  SizedBox buildCommentBody(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    radius: 50,
                    foregroundImage: CachedNetworkImageProvider(
                        'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                    backgroundImage:
                        AssetImage("assets/images/music_default.jpg"),
                  ),
                ),
                paddingWidth(0.5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lâm • 1 hours ago',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 13, color: Colors.grey),
                      ),
                      paddingHeight(0.5),
                      Text(
                        'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                      paddingHeight(0.5),
                      Row(
                        children: [
                          const Icon(
                            Ionicons.heart_outline,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const Text(
                            ' | ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Reply',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 30,
                  child: Icon(
                    Icons.more_vert,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
          paddingHeight(1),
          Padding(
            padding: const EdgeInsets.only(
                left: defaultPadding + 48, right: defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    radius: 50,
                    foregroundImage: CachedNetworkImageProvider(
                        'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                    backgroundImage:
                        AssetImage("assets/images/music_default.jpg"),
                  ),
                ),
                paddingWidth(0.5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lâm • 1 hours ago',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 13, color: Colors.grey),
                      ),
                      paddingHeight(0.5),
                      Text(
                        'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                      paddingHeight(0.5),
                      Row(
                        children: [
                          const Icon(
                            Ionicons.heart_outline,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const Text(
                            ' | ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Reply',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 30,
                  child: Icon(
                    Icons.more_vert,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
          paddingHeight(1),
          Padding(
            padding: const EdgeInsets.only(
                left: defaultPadding + 48, right: defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    radius: 50,
                    foregroundImage: CachedNetworkImageProvider(
                        'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                    backgroundImage:
                    AssetImage("assets/images/music_default.jpg"),
                  ),
                ),
                paddingWidth(0.5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lâm • 1 hours ago',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 13, color: Colors.grey),
                      ),
                      paddingHeight(0.5),
                      Text(
                        'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                        softWrap: true,
                      ),
                      paddingHeight(0.5),
                      Row(
                        children: [
                          const Icon(
                            Ionicons.heart_outline,
                            color: Colors.grey,
                            size: 16,
                          ),
                          const Text(
                            ' | ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Reply',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 30,
                  child: Icon(
                    Icons.more_vert,
                    size: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ControlMusicButtons extends StatelessWidget {
  const ControlMusicButtons({Key? key, required this.player}) : super(key: key);
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return IconButton(
              icon: shuffleModeEnabled
                  ? Icon(Ionicons.shuffle,
                      color: ColorsConsts.primaryColorLight, size: 30)
                  : const Icon(Ionicons.shuffle, color: Colors.grey, size: 30),
              style: IconButton.styleFrom(
                  elevation: 0, padding: const EdgeInsets.all(0)),
              onPressed: () async {
                final enable = !shuffleModeEnabled;
                if (enable) {
                  await player.shuffle();
                }
                await player.setShuffleModeEnabled(enable);
              },
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Ionicons.play_skip_back),
            style: IconButton.styleFrom(
                elevation: 0, padding: const EdgeInsets.all(0)),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        playButton(),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Ionicons.play_skip_forward),
            style: IconButton.styleFrom(
                elevation: 0, padding: const EdgeInsets.all(0)),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            final icons = [
              const Icon(Icons.repeat, color: Colors.grey, size: 30),
              Icon(Icons.repeat,
                  color: ColorsConsts.primaryColorLight, size: 30),
              Icon(Icons.repeat_one,
                  color: ColorsConsts.primaryColorLight, size: 30),
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one,
            ];
            final index = cycleModes.indexOf(loopMode);
            return IconButton(
              icon: icons[index],
              style: IconButton.styleFrom(
                  elevation: 0, padding: const EdgeInsets.all(0)),
              onPressed: () {
                player.setLoopMode(cycleModes[
                    (cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
              },
            );
          },
        ),
      ],
    );
  }

  StreamBuilder<PlayerState> playButton() {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (playing != true ||
            processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              onPressed: player.play,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.all(0),
              ),
              child: const Icon(Ionicons.play, size: 32),
            ),
          );
        } else if (processingState != ProcessingState.completed) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius * 4)),
            child: ElevatedButton(
              onPressed: player.pause,
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.all(0),
                  shape: const CircleBorder()),
              child: const Icon(Ionicons.pause, size: 32),
            ),
          );
        } else {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius * 4)),
            child: ElevatedButton(
              onPressed: () => player.seek(Duration.zero),
              style: ElevatedButton.styleFrom(
                  elevation: 0, padding: const EdgeInsets.all(0)),
              child: const Icon(Icons.replay, size: 32),
            ),
          );
        }
      },
    );
  }
}
