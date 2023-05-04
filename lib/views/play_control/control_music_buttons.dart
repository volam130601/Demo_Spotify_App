import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';

import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';

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
