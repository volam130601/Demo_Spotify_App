import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/view_models/library/library_view_model.dart';
import 'package:demo_spotify_app/views/library/library_screen.dart';
import 'package:demo_spotify_app/widgets/list_tile_custom/list_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../data/network/firebase/playlist_new_service.dart';
import '../../models/firebase/playlist_new.dart';
import '../../models/track.dart';
import '../../view_models/library/box_search_track.dart';
import '../../view_models/multi_control_player_view_model.dart';
import '../../widgets/list_tile_custom/track_tile_item.dart';
import '../layout_screen.dart';

class AddPlaylistDetailScreen extends StatefulWidget {
  const AddPlaylistDetailScreen({Key? key, required this.playlistNew})
      : super(key: key);
  final PlaylistNew playlistNew;

  @override
  State<AddPlaylistDetailScreen> createState() =>
      _AddPlaylistDetailScreenState();
}

class _AddPlaylistDetailScreenState extends State<AddPlaylistDetailScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LibraryViewModel>(context, listen: false)
        .fetchTrackSuggestApi(widget.playlistNew.title!, 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          PlaylistNewService.instance
                              .deleteItem(widget.playlistNew.id.toString());
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation1,
                                  Animation<double> animation2) {
                                return const LayoutScreen(
                                  index: 2,
                                  screen: LibraryScreen(),
                                );
                              },
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                          print('remove this playlist');
                        },
                        child: const ListTile(
                          leading: Icon(Icons.remove_circle),
                          title: Text('Remove this playlist'),
                        ),
                      )
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: StreamBuilder(
        stream: PlaylistNewService.instance.getPlaylistNewByPlaylistIdAndUserId(
            widget.playlistNew.id.toString(), CommonUtils.userId),
        builder: (context, snapshot) {
          Widget body;
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          if (!snapshot.hasData) {
            body = Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: Text(
                'Your playlist is currently empty. Please add some songs to it.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            );
            return SizedBox(
              height: MediaQuery.of(context).size.height - 300,
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          }
          List<Track>? tracks = snapshot.data;

          if (tracks!.isNotEmpty) {
            body = SizedBox(
              height: tracks.length * (50 + 16),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => TrackTileItem(
                  track: tracks[index],
                  album: tracks[index].album,
                  playlistNew: widget.playlistNew,
                ),
                itemCount: tracks.length,
              ),
            );
          } else {
            body = Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              child: Text(
                'Your playlist is currently empty. Please add some songs to it.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeaderContent(context, tracks),
                    paddingHeight(1),
                    buildAction(context, tracks),
                    paddingHeight(2),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: body,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildAction(BuildContext context, List<Track> tracks) {
    if (tracks.isNotEmpty) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Ionicons.arrow_down_circle_outline)),
              Text(
                'Download',
                style: Theme.of(context).textTheme.titleSmall,
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              var value =
                  Provider.of<MultiPlayerViewModel>(context, listen: false);
              value.initState(tracks: tracks, index: 0);
            },
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 3, vertical: defaultPadding),
              side: const BorderSide(width: 1, color: Colors.grey),
            ),
            child: Text(
              'PLAY MUSIC',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return LayoutScreen(
                            index: 4,
                            screen: BoxSearchTrack(
                              playlistNew: widget.playlistNew,
                            ),
                          );
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  icon: const Icon(Ionicons.add_circle_outline)),
              Text(
                'Add track',
                style: Theme.of(context).textTheme.titleSmall,
              )
            ],
          ),
        ],
      );
    } else {
      return Center(
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (BuildContext context,
                    Animation<double> animation1,
                    Animation<double> animation2) {
                  return LayoutScreen(
                    index: 4,
                    screen: BoxSearchTrack(
                      playlistNew: widget.playlistNew,
                    ),
                  );
                },
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 3, vertical: defaultPadding),
            side: const BorderSide(width: 1, color: Colors.grey),
          ),
          child: Text(
            'ADD TRACK',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget buildHeaderContent(BuildContext context, List<Track> tracks) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.width * .5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
              child: (widget.playlistNew.picture != null)
                  ? CachedNetworkImage(
                      imageUrl: widget.playlistNew.picture.toString(),
                      placeholder: (context, url) => Image.asset(
                        'assets/images/music_default.jpg',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/music_default.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          paddingHeight(1),
          Text(
            '${widget.playlistNew.title}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          paddingHeight(0.2),
          Text(
            '${widget.playlistNew.userName}',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          paddingHeight(0.2),
          Text(
            '${tracks.length} track • ${CommonUtils.convertTotalDuration(tracks)}',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
