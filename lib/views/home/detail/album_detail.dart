import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/album.dart';
import '../../../models/artist.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../view_models/track_play_view_model.dart';
import '../components/play_control/play_button.dart';

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({Key? key, this.album, this.artist}) : super(key: key);
  final Album? album;
  final Artist? artist;

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  final ScrollController _scrollController = ScrollController();
  late bool isShow = false;
  late bool isCheckScrollExtendAfter = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<TrackPlayViewModel>(context, listen: false)
      ..fetchTracksByAlbumID(widget.album!.id as int, 0, 10)
      ..fetchTracksPlayControl(
          albumID: widget.album!.id as int, index: 0, limit: 20);

    setIsLoading();
    _scrollController.addListener(_onScrollEvent);
  }

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      isLoading = false;
    });
  }

  void setIsShow(newValue) {
    setState(() {
      isShow = newValue;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  void scrollTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onScrollEvent() {
    final extentBefore = _scrollController.position.extentBefore;
    if (extentBefore >= 347.4051339285647) {
      setIsShow(true);
    } else {
      setIsShow(false);
    }

    final extentAfter = _scrollController.position.extentAfter;
    if (extentAfter <= 100.0) {
      setState(() {
        // isCheckScrollExtendAfter = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      return Scaffold(
        body: Stack(
          children: [
            buildAlbumDetailBody(context),
            isShow
                ? Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Container(
                        color: ColorsConsts.scaffoldColorDark,
                        child: playlistActions()))
                : const SizedBox(),
          ],
        ),
      );
    }
  }

  Widget buildAlbumDetailBody(BuildContext context) {
    String artistAvatar;
    String artistName;
    if (widget.artist != null) {
      artistAvatar = widget.artist!.pictureSmall as String;
      artistName = widget.artist!.name as String;
    } else {
      artistAvatar = widget.album!.artist!.pictureSmall as String;
      artistName = widget.album!.artist!.name as String;
    }
    return Consumer<TrackPlayViewModel>(
      builder: (context, value, _) {
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
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                buildAppBar(value, context),
                buildSelectionTitle(context),
                SliverToBoxAdapter(
                  child: playlistActions(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return playlistTile(context, tracks[index]);
                    },
                    childCount: tracks!.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('March 2 ,2023',
                            style: Theme.of(context).textTheme.titleMedium),
                        paddingHeight(1.5),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(artistAvatar),
                              radius: 20,
                            ),
                            paddingWidth(1.5),
                            Text(artistName,
                                style: Theme.of(context).textTheme.titleMedium)
                          ],
                        ),
                        paddingHeight(5),
                      ],
                    ),
                  ),
                )
              ],
            );
          case Status.ERROR:
            return Text(value.tracks.toString());
          default:
            return const Text('Default Switch');
        }
      },
    );
  }

  SliverToBoxAdapter buildSelectionTitle(BuildContext context) {
    String artistAvatar;
    String artistName;
    if (widget.artist != null) {
      artistAvatar = widget.artist!.pictureSmall as String;
      artistName = widget.artist!.name as String;
    } else {
      artistAvatar = widget.album!.artist!.pictureSmall as String;
      artistName = widget.album!.artist!.name as String;
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 2, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.album!.title as String,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: CachedNetworkImageProvider(
                    artistAvatar,
                  ),
                ),
                const SizedBox(width: defaultPadding / 2),
                Text(
                  artistName,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            Text('Album - 2023',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(TrackPlayViewModel value, BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          value.tracks.data = [];
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      pinned: true,
      backgroundColor: ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: CachedNetworkImageProvider(widget.album!.coverXl as String),
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.downloading)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
        PlayButton(
          tracks: Provider.of<TrackPlayViewModel>(context, listen: false)
              .tracksPlayControl
              .data!,
          album: widget.album,
          artist: (widget.artist != null) ? widget.artist: widget.album!.artist,
          albumId: widget.album!.id,
        ),
        const SizedBox(width: defaultPadding)
      ],
    );
  }

  Widget playlistTile(BuildContext context, Track? track) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              track!.title as String,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  color: Colors.grey,
                  child: const Text(
                    'E',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(width: defaultPadding / 2),
                Text(
                  track.artist!.name as String,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
