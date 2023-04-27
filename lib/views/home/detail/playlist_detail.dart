import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/network/firebase/favorite_playlist_service.dart';
import 'package:demo_spotify_app/models/firebase/favorite_playlist.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/view_models/download_view_modal.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/view_models/playlist_view_model.dart';
import 'package:demo_spotify_app/widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/playlist.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../utils/toast_utils.dart';
import '../../../widgets/action/action_download_track.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<PlaylistViewModel>(context, listen: false)
      ..fetchPlaylistById(widget.playlistId)
      ..fetchTracksByPlaylistId(widget.playlistId, 0, 10000);

    setIsLoading();
    _scrollController.addListener(_onScrollEvent);
  }

  void setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      isLoading = false;
    });
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

    final extentAfter = _scrollController.position.extentAfter;
    if (extentAfter == 0.0) {
      setState(() {
        isCheckScrollExtendAfter = true;
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
      body: Stack(
        children: [
          buildPlaylistBody(context),
          isLoading
              ? Scaffold(
                  body: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget buildPlaylistBody(BuildContext context) {
    return Consumer<PlaylistViewModel>(builder: (context, value, _) {
      // ignore: unrelated_type_equality_checks
      if (value.tracks.data == Status.LOADING ||
          // ignore: unrelated_type_equality_checks
          value.playlistDetail.data == Status.LOADING) {
        return Scaffold(
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      }
      List<Track>? tracks = value.tracks.data;
      Playlist? playlist = value.playlistDetail.data;
      if (playlist != null && tracks != null) {
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
                        child: playlistTile(context, tracks[index], playlist),
                        onTap: () {
                          var value = Provider.of<MultiPlayerViewModel>(context,
                              listen: false);
                          int? currentPlaylistId = playlist.id;
                          if (currentPlaylistId != value.getPlaylistId) {
                            value.initState(
                                tracks: tracks,
                                playlistId: playlist.id,
                                index: index);
                          } else {
                            value.player.seek(Duration.zero, index: index);
                          }
                        },
                      );
                    },
                    childCount: tracks.length,
                  ),
                ),
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
      } else {
        return Scaffold(
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      }
    });
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
            stream: FavoritePlaylistService.instance
                .getPlaylistItemsByUserId(userId: CommonUtils.userId),
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
                        FavoritePlaylistService.instance.deleteItemByPlaylistId(
                            playlist.id.toString(), CommonUtils.userId);
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
                        FavoritePlaylistService.instance
                            .addItem(FavoritePlaylist(
                          id: DateTime.now().toString(),
                          playlistId: playlist.id.toString(),
                          title: playlist.title,
                          userName: (playlist.user != null)
                              ? playlist.user!.name.toString()
                              : playlist.creator!.name.toString(),
                          pictureMedium: playlist.pictureMedium,
                          userId: CommonUtils.userId,
                        ));
                      },
                      icon: const Icon(Ionicons.heart_outline));
            }),
        ActionDownloadTracks(
          playlist: playlist,
          tracks: tracks,
          sizeFileDownload: (value.totalSizeDownload != '')
              ? value.totalSizeDownload
              : '0.0 MB',
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
        PlayButton(
          tracks: tracks,
          playlistId: playlist.id,
        ),
        const SizedBox(width: defaultPadding)
      ],
    ); // Show the fetched data.
  }

  Widget playlistTile(BuildContext context, Track track, Playlist playlist) {
    return Consumer<DownloadViewModel>(
      builder: (context, value, child) {
        final bool isDownloaded =
            value.trackDownloads.any((item) => item.id == track.id!);
        return TrackTileItem(
          track: track,
          playlist: playlist,
          isDownloaded: isDownloaded,
        );
      },
    );
  }
}
