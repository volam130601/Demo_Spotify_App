import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/artist.dart';
import 'package:demo_spotify_app/models/local/album_download.dart';
import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/track.dart';
import '../../../repository/local/download_repository.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../widgets/play_control/play_button.dart';

class AlbumDetailDownload extends StatefulWidget {
  const AlbumDetailDownload({Key? key, required this.albumDownload})
      : super(key: key);
  final AlbumDownload albumDownload;

  @override
  State<AlbumDetailDownload> createState() => _AlbumDetailDownloadState();
}

class _AlbumDetailDownloadState extends State<AlbumDetailDownload> {
  final ScrollController _scrollController = ScrollController();
  late bool isShow = false;
  late bool isCheckScrollExtendAfter = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrackDownload>>(
      future: DownloadRepository.instance
          .getTracksByAlbumId(widget.albumDownload.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Track> tracks =
              CommonUtils.convertTrackDownloadsToTracks(snapshot.data!);
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              buildAppBar(context),
              buildSelectionTitle(context, widget.albumDownload),
              SliverToBoxAdapter(
                child: albumActions(tracks, widget.albumDownload),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return playlistTile(context, tracks[index]);
                  },
                  childCount: tracks.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          CommonUtils.formatReleaseDate(
                              widget.albumDownload.releaseDate!),
                          style: Theme.of(context).textTheme.titleMedium),
                      paddingHeight(1.5),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                widget.albumDownload.pictureSmall.toString()),
                            radius: 20,
                          ),
                          paddingWidth(1.5),
                          Text(widget.albumDownload.artistName.toString(),
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

  SliverToBoxAdapter buildSelectionTitle(
      BuildContext context, AlbumDownload album) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 2, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              album.title.toString(),
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
                    album.pictureSmall.toString(),
                  ),
                ),
                const SizedBox(width: defaultPadding / 2),
                Text(
                  album.artistName.toString(),
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

  SliverAppBar buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: CachedNetworkImageProvider(
              widget.albumDownload.coverXl.toString()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row albumActions(List<Track> tracks, AlbumDownload album) {
    return Row(
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.favorite_border_sharp)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
        PlayButton(
          tracks: tracks,
          artist: Artist(pictureSmall: album.pictureSmall),
          albumId: album.id,
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
