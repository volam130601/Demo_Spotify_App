import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/view_models/downloader/download_view_modal.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/view_models/playlist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/playlist.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../widgets/action/action_download_track.dart';
import '../../../widgets/action/action_more.dart';
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
      ..fetchTracksByPlaylistId(widget.playlistId, 0, 10000)
      ..fetchPlaylistById(widget.playlistId);

    setIsLoading();
    _scrollController.addListener(_onScrollEvent);
  }

  void setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 700));
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
      switch (value.tracks.status) {
        case Status.LOADING:
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        case Status.COMPLETED:
          List<Track>? tracks = value.tracks.data;
          Playlist? playlist = value.playlistDetail.data;
          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  buildAppBar(context, playlist!),
                  buildHeaderBody(context, playlist),
                  SliverToBoxAdapter(
                    child: playlistActions(tracks!, playlist),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return InkWell(
                          child: playlistTile(context, tracks[index], playlist),
                          onTap: () {
                            var value = Provider.of<MultiPlayerViewModel>(
                                context,
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
                ],
              ),
            ],
          );
        case Status.ERROR:
          return Text(value.tracks.toString());
        default:
          return const Text('Default Switch');
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
                '${playlist.nbTracks} likes - ${CommonUtils.totalDuration(playlist.duration!)}',
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

  Row playlistActions(List<Track> tracks, Playlist playlist) {
    return Row(
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.favorite_border_sharp)),
        ActionDownloadTracks(
          playlist: playlist,
          tracks: tracks,
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
    );
  }

  Widget playlistTile(BuildContext context, Track track, Playlist playlist) {
    return Consumer<DownloadViewModel>(
      builder: (context, value, child) {
        final trackDownloads = value.trackDownloads;
        final bool isDownloaded =
            trackDownloads.any((item) => item.id == track.id!);
        return Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: defaultPadding),
          child: ListTile(
            leading: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: track.album!.coverSmall as String,
              fit: BoxFit.cover,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  track.title as String,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    isDownloaded
                        ? Row(
                            children: [
                              const Icon(Icons.download_for_offline_outlined,
                                  color: Colors.deepPurple),
                              paddingWidth(0.5),
                            ],
                          )
                        : const SizedBox(),
                    Text(
                      track.artist!.name as String,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            trailing: ActionMore(
              track: track,
              playlist: playlist,
              isDownloaded: isDownloaded,
            ),
          ),
        );
      },
    );
  }
}
