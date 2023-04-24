import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/view_models/downloader/download_view_modal.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/playlist.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../view_models/track_play_view_model.dart';
import '../../../widgets/action/action_download_playlist.dart';
import '../../../widgets/action/action_more.dart';
import '../../../widgets/play_control/play_button.dart';

class PlaylistDetail extends StatefulWidget {
  const PlaylistDetail({Key? key, required this.playlist, this.userName})
      : super(key: key);
  final Playlist? playlist;
  final String? userName;

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

    Provider.of<TrackPlayViewModel>(context, listen: false)
        .fetchTracksPlayControl(
            playlistID: widget.playlist!.id as int, index: 0, limit: 20);

    setIsLoading();
    _scrollController.addListener(_onScrollEvent);
  }

  Future<void> setIsLoading() async {
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
    return Consumer<TrackPlayViewModel>(builder: (context, value, _) {
      switch (value.tracksPlayControl.status) {
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
          return Scaffold(
            body: Stack(
              children: [
                buildPlaylistBody(context, value),
                if (isShow) ...{
                  Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Container(
                          color: ColorsConsts.scaffoldColorDark,
                          child: playlistActions())),
                }
              ],
            ),
          );
        case Status.ERROR:
          return Text(value.tracksPlayControl.toString());
        default:
          return const Text('Default Switch');
      }
    });
  }

  Widget buildPlaylistBody(BuildContext context, TrackPlayViewModel value) {
    List<Track>? tracks = value.tracksPlayControl.data;
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 40,
          ),
        ),
      );
    } else {
      return CustomScrollView(
        controller: _scrollController,
        slivers: [
          buildAppBar(value, context),
          buildHeaderBody(context, value),
          SliverToBoxAdapter(
            child: playlistActions(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: tracks!.length < 50 ? tracks.length * 60 : 50 * 60,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: defaultPadding * 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    child: playlistTile(context, tracks[index]),
                    onTap: () {
                      var value = Provider.of<MultiPlayerViewModel>(context,
                          listen: false);
                      int? currentPlaylistId = widget.playlist!.id as int;
                      if (currentPlaylistId != value.getPlaylistId) {
                        value.initState(
                            tracks: tracks,
                            playlistId: widget.playlist!.id as int,
                            index: index);
                      } else {
                        value.player.seek(Duration.zero, index: index);
                      }
                    },
                  );
                },
                itemCount: tracks.length < 50 ? tracks.length : 50,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Center(
                  child: OutlinedButton(
                    onPressed: () {},
                    style:
                        OutlinedButton.styleFrom(shape: const StadiumBorder()),
                    child: Text(
                      'See all tracks',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding * 5),
              ],
            ),
          ),
        ],
      );
    }
  }

  SliverToBoxAdapter buildHeaderBody(
      BuildContext context, TrackPlayViewModel value) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 2, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.playlist!.title as String,
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
                  (widget.userName != null)
                      ? '${widget.userName}'
                      : '${widget.playlist!.user!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            Text('${widget.playlist!.nbTracks} tracks - ${value.totalDuration}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(TrackPlayViewModel provider, BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          provider.tracks.data = [];
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      pinned: true,
      backgroundColor: ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image:
              CachedNetworkImageProvider(widget.playlist!.pictureXl as String),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row playlistActions() {
    return Row(
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.favorite_border_sharp)),
        ActionDownloadPlaylist(
          playlist: widget.playlist!,
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
        PlayButton(
          tracks: Provider.of<TrackPlayViewModel>(context, listen: false)
              .tracksPlayControl
              .data!,
          playlistId: widget.playlist!.id,
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
                imageUrl: widget.playlist!.pictureMedium as String,
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
            widget.playlist!.title as String,
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
                (widget.userName != null)
                    ? widget.userName as String
                    : widget.playlist!.user!.name as String,
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

  Widget playlistTile(BuildContext context, Track track) {
    final isDownloaded = Provider.of<DownloadViewModel>(context, listen: true)
        .checkExistTrackId(track.id!);
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
          playlist: widget.playlist!,
          isDownloaded: isDownloaded,
        ),
      ),
    );
  }
}
