import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/res/components/slide_animation_page_route.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../res/constants/default_constant.dart';
import '../widgets/play_control/common.dart';
import 'home/play_control/track_play.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key, required this.index, required this.screen})
      : super(key: key);
  final int index;
  final Widget screen;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<LayoutScreenViewModel>(context, listen: false).setScreenWidget();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;
    if (widget.index > 3) {
      screen = widget.screen;
    } else {
      screen = Provider.of<LayoutScreenViewModel>(context, listen: true).screen;
    }
    bool isShowBottomNavigatorBar =
        Provider.of<LayoutScreenViewModel>(context, listen: true).isShowBottomBar;
    return Scaffold(
      body: Stack(
        children: [
          screen,
          isShowBottomNavigatorBar
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      showPlayMusicCard(context),
                      const BottomNavigatorBarCustom(),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget showPlayMusicCard(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    final providerMultiPlayer =
        Provider.of<MultiPlayerViewModel>(context, listen: true);
    Widget? playMusicCard;
    if (providerMultiPlayer.isCheckPlayer) {
      playMusicCard = InkWell(
        onTap: () {
          Navigator.of(context)
              .push(SlideTopPageRoute(page: const TrackPlay()));
        },
        child: Container(
          height: 60,
          width: widthScreen,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(defaultBorderRadius / 2)),
          margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          child: Stack(
            children: [
              StreamBuilder<SequenceState?>(
                stream: providerMultiPlayer.player.sequenceStateStream,
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
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius / 2),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: metadata.artUri.toString(),
                          placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
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
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              metadata.artist as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey.shade300),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: providerMultiPlayer.player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering) {
                            return Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colors.white,
                                size: 28,
                              ),
                            );
                          } else if (playing != true) {
                            return IconButton(
                              onPressed: providerMultiPlayer.player.play,
                              icon: const Icon(Icons.play_arrow, size: 32),
                            );
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return IconButton(
                              onPressed: providerMultiPlayer.player.pause,
                              icon: const Icon(Ionicons.pause, size: 32),
                            );
                          } else {
                            return IconButton(
                              onPressed: () => providerMultiPlayer.player
                                  .seek(Duration.zero),
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
                  stream: providerMultiPlayer.positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                          positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: providerMultiPlayer.player.seek,
                      isShow: false,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    } else {
      playMusicCard = const SizedBox();
    }
    return playMusicCard;
  }
}

class BottomNavigatorBarCustom extends StatefulWidget {
  const BottomNavigatorBarCustom({Key? key})
      : super(key: key);

  @override
  State<BottomNavigatorBarCustom> createState() =>
      _BottomNavigatorBarCustomState();
}

class _BottomNavigatorBarCustomState extends State<BottomNavigatorBarCustom> {
  @override
  Widget build(BuildContext context) {
    final mainScreenProvider = Provider.of<LayoutScreenViewModel>(context);
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.8), // red with 50% opacity
                  Color.fromRGBO(0, 0, 0, 1), // green with 50% opacity
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavigatorItemChild(
                index: 0,
                iconSelected: const Icon(IconlyBold.home),
                iconUnSelected: const Icon(IconlyLight.home),
                label: 'Home',
                onTap: () {
                  mainScreenProvider.setPageIndex(0);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 0, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              BottomNavigatorItemChild(
                index: 1,
                iconSelected: const Icon(IconlyBold.search),
                iconUnSelected: const Icon(IconlyLight.search),
                label: 'Search',
                onTap: () {
                  mainScreenProvider.setPageIndex(1);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 1, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              BottomNavigatorItemChild(
                index: 2,
                iconSelected: const Icon(IconlyBold.folder),
                iconUnSelected: const Icon(IconlyLight.folder),
                label: 'Library',
                onTap: () {
                  mainScreenProvider.setPageIndex(2);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 2, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              BottomNavigatorItemChild(
                index: 3,
                iconSelected: const Icon(IconlyBold.profile),
                iconUnSelected: const Icon(IconlyLight.profile),
                label: 'Profile',
                onTap: () {
                  mainScreenProvider.setPageIndex(3);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 3, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomNavigatorItemChild extends StatefulWidget {
  const BottomNavigatorItemChild({
    Key? key,
    required this.index,
    required this.iconSelected,
    required this.iconUnSelected,
    required this.label,
    this.onTap,
  }) : super(key: key);
  final int index;
  final Widget iconSelected;
  final Widget iconUnSelected;
  final String label;
  final VoidCallback? onTap;

  @override
  State<BottomNavigatorItemChild> createState() =>
      _BottomNavigatorItemChildState();
}

class _BottomNavigatorItemChildState extends State<BottomNavigatorItemChild> {
  @override
  Widget build(BuildContext context) {
    final mainScreenProvider = Provider.of<LayoutScreenViewModel>(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: 80,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (widget.index == mainScreenProvider.pageIndex)
                    ? widget.iconSelected
                    : widget.iconUnSelected,
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
