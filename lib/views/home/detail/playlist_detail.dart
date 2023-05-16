import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/view_models/home/playlist_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play/multi_control_player_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/playlist.dart';
import '../../../repository/remote/firebase/favorite_playlist_repository.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../utils/toast_utils.dart';
import '../../../widgets/action/action_download_multi_tracks.dart';
import '../../../widgets/list_tile_custom/track_tile_item.dart';
import '../../../widgets/play_control/play_button.dart';

class PlaylistDetail extends StatefulWidget {
  const PlaylistDetail({Key? key, this.userName, required this.playlistId})
      : super(key: key);
  final String? userName;
  final int playlistId;

  @override
  State<PlaylistDetail> createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  final ScrollController _scrollController = ScrollController();
  late bool isCheckScrollExtendAfter = false;
  late bool isShow = false;
  int page = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<PlaylistViewModel>(context, listen: false)
      ..fetchPlaylistById(widget.playlistId)
      ..fetchTracksPagingByPlaylistId(widget.playlistId, 0, 10);
    _scrollController.addListener(_onScrollEvent);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  void _onScrollEvent() {
    final extentBefore = _scrollController.position.extentBefore;
    if (extentBefore >= 347.4051339285647) {
      setIsShow(true);
    } else {
      setIsShow(false);
    }

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        page += 10;
        Provider.of<PlaylistViewModel>(context, listen: false)
          ..setIsLoading(true)
          ..fetchTracksPagingByPlaylistId(widget.playlistId, page, 10);
      });
    }
  }

  void setIsShow(newValue) {
    setState(() {
      isShow = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlaylistViewModel>(builder: (context, value, _) {
        if (value.playlistDetail.status == Status.LOADING ||
            value.tracksPaging.isEmpty) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }
        if (value.playlistDetail.status == Status.ERROR) {
          ToastCommon.showCustomText(content: 'Loading playlist error');
        }
        List<Track> tracks = value.tracksPaging;
        Playlist playlist = value.playlistDetail.data!;
        return Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                buildAppBar(context, playlist),
                buildHeaderBody(context, playlist),
                SliverToBoxAdapter(
                  child: playlistActions(tracks, playlist, value),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        child: TrackTileItem(
                          track: tracks[index],
                          playlist: playlist,
                          onTap: () {
                            var value = Provider.of<MultiPlayerViewModel>(
                                context,
                                listen: false);
                            value.initState(
                                tracks: tracks,
                                playlistId: playlist.id,
                                index: index);
                          },
                        ),
                      );
                    },
                    childCount: tracks.length,
                  ),
                ),
                if (value.isLoading) ...{
                  const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                },
                SliverToBoxAdapter(child: paddingHeight(8)),
              ],
            ),
            if (isShow) ...{
              Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Container(
                      color: ColorsConsts.scaffoldColorDark,
                      child: playlistActions(tracks, playlist, value))),
            }
          ],
        );
      }),
    );
  }

  SliverToBoxAdapter buildHeaderBody(BuildContext context, Playlist playlist) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 2, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              playlist.title as String,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            paddingHeight(0.5),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/spotify_logo.svg',
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: defaultPadding / 2),
                Text(
                  (widget.userName != null)
                      ? widget.userName.toString()
                      : (playlist.user != null)
                          ? playlist.user!.name.toString()
                          : playlist.creator!.name.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
            paddingHeight(0.5),
            Text(
                '${playlist.nbTracks} tracks • ${CommonUtils.totalDuration(playlist.duration!)}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context, Playlist playlist) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: CachedNetworkImageProvider(playlist.pictureXl as String),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget playlistActions(
      List<Track> tracks, Playlist playlist, PlaylistViewModel value) {
    return Row(
      children: [
        StreamBuilder(
            stream: FavoritePlaylistRepository.instance
                .getPlaylistItemsByUserId(
                    userId: FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return IconButton(
                  onPressed: () {},
                  icon: const Icon(Ionicons.heart_outline),
                );
              }
              final isAddedFavoritePlaylist = snapshot.data!.any(
                  (element) => element.playlistId == playlist.id.toString());

              return isAddedFavoritePlaylist
                  ? IconButton(
                      onPressed: () {
                        ToastCommon.showCustomText(
                            content:
                                'Removed playlist ${playlist.title} from the library');
                        FavoritePlaylistRepository.instance
                            .deleteFavoritePlaylistByPlaylistId(
                                playlist.id.toString());
                      },
                      icon: Icon(
                        Ionicons.heart,
                        color: ColorsConsts.primaryColorDark,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        ToastCommon.showCustomText(
                            content:
                                'Added playlist ${playlist.title} to the library');
                        FavoritePlaylistRepository.instance
                            .addFavoritePlaylist(playlist);
                      },
                      icon: const Icon(Ionicons.heart_outline));
            }),
        ActionDownloadTracks(
          playlist: playlist,
          tracks: tracks,
          sizeFileDownload: value.totalSizeDownload,
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        const Spacer(),
        Consumer<MultiPlayerViewModel>(
          builder: (context, value, child) => StreamBuilder<bool>(
            stream: value.player.shuffleModeEnabledStream,
            builder: (context, snapshot) {
              final shuffleModeEnabled = snapshot.data ?? false;
              return IconButton(
                icon: shuffleModeEnabled
                    ? Icon(Ionicons.shuffle,
                        color: ColorsConsts.primaryColorLight, size: 30)
                    : const Icon(Ionicons.shuffle,
                        color: Colors.grey, size: 30),
                style: IconButton.styleFrom(
                    elevation: 0, padding: const EdgeInsets.all(0)),
                onPressed: () async {
                  final enable = !shuffleModeEnabled;
                  if (enable) {
                    await value.player.shuffle();
                  }
                  await value.player.setShuffleModeEnabled(enable);
                },
              );
            },
          ),
        ),
        PlayButton(
          tracks: tracks,
          playlistId: playlist.id,
        ),
        const SizedBox(width: defaultPadding)
      ],
    ); // Show the fetched data.
  }
}
