import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/local/playlist_download.dart';
import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:demo_spotify_app/repository/local/download_repository.dart';
import 'package:demo_spotify_app/view_models/downloader/download_view_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../../utils/common_utils.dart';
import '../../../view_models/multi_control_player_view_model.dart';
import '../../../widgets/play_control/play_button.dart';
import '../../../models/track.dart';

class PlaylistDetailDownload extends StatefulWidget {
  const PlaylistDetailDownload({Key? key, required this.playlistDownload})
      : super(key: key);
  final PlaylistDownload playlistDownload;

  @override
  State<PlaylistDetailDownload> createState() => _PlaylistDetailDownloadState();
}

class _PlaylistDetailDownloadState extends State<PlaylistDetailDownload> {
  final ScrollController _scrollController = ScrollController();
  late bool isCheckScrollExtendAfter = false;
  late bool isShow = false;

  @override
  void initState() {
    super.initState();
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
      setState(() {
        isShow = true;
      });
    } else {
      setState(() {
        isShow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrackDownload>>(
      future: DownloadRepository.instance
          .getTracksByPlaylistId(widget.playlistDownload.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Track> tracks = CommonUtils
              .convertTrackDownloadsToTracks(snapshot.data!);
          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  buildAppBar(context),
                  buildHeaderBody(context, tracks),
                  SliverToBoxAdapter(
                    child: playlistActions(tracks),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: (tracks.length + 4) * 60,
                      child: ListView.builder(
                        padding:  const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            height: 60,
                            margin:
                                const EdgeInsets.only(bottom: defaultPadding),
                            child: InkWell(
                              child:
                                  playlistTile(context, snapshot.data![index]),
                              onTap: () {
                                var value = Provider.of<MultiPlayerViewModel>(
                                    context,
                                    listen: false);
                                int? currentPlaylistId = int.parse(
                                    widget.playlistDownload.id.toString());
                                if (currentPlaylistId != value.getPlaylistId) {
                                  value.initState(
                                      tracks: tracks,
                                      playlistId: int.parse(widget
                                          .playlistDownload.id
                                          .toString()),
                                      index: index);
                                } else {
                                  value.player
                                      .seek(Duration.zero, index: index);
                                }
                              },
                            ),
                          );
                        },
                        itemCount: tracks.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: paddingHeight(8),
                  )
                ],
              ),
              if (isShow) ...{
                Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Container(
                        color: ColorsConsts.scaffoldColorDark,
                        child: playlistActions(tracks))),
              }
            ],
          );
        }
        return Scaffold(
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  SliverToBoxAdapter buildHeaderBody(BuildContext context, List<Track> tracks) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 2, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.playlistDownload.title.toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: defaultPadding / 2),
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
                  '${widget.playlistDownload.userName}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
                '${tracks.length} tracks - ${CommonUtils.convertTotalDuration(tracks)}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: CachedNetworkImageProvider(
              widget.playlistDownload.pictureXl as String),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row playlistActions(List<Track> tracks) {
    return Row(
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.favorite_border_sharp)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
        PlayButton(
          tracks: tracks,
          playlistId: widget.playlistDownload.id,
        ),
        const SizedBox(width: defaultPadding)
      ],
    );
  }

  Padding playlistInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 150,
              height: 150,
              margin: const EdgeInsets.only(top: 40),
              child: CachedNetworkImage(
                imageUrl: widget.playlistDownload.pictureMedium as String,
                placeholder: (context, url) => Image.asset(
                  'assets/images/music_default.jpg',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            widget.playlistDownload.title as String,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: defaultPadding / 2),
          Row(
            children: [
              SvgPicture.network(
                'https://upload.wikimedia.org/wikipedia/commons/8/84/Spotify_icon.svg',
                fit: BoxFit.cover,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                widget.playlistDownload.userName.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Text('33.856 likes - 2h 52min',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget playlistTile(BuildContext context, TrackDownload track) {
    final isDownloaded = Provider.of<DownloadViewModel>(context, listen: true)
        .checkExistTrackId(track.id!);
    return ListTile(
      leading: CachedNetworkImage(
        width: 50,
        height: 50,
        imageUrl: track.coverSmall as String,
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
                track.artistName as String,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
      /* trailing: ActionMore(
        track: track,
        playlistId: widget.playlistDownload.playlistId.toString(),
        isDownloaded: isDownloaded,
      ),*/
    );
  }
}
