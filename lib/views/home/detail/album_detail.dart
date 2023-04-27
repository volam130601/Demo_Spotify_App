import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/view_models/album_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/network/firebase/favorite_album_service.dart';
import '../../../data/response/status.dart';
import '../../../models/album.dart';
import '../../../models/firebase/favorite_album.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../utils/toast_utils.dart';
import '../../../view_models/download_view_modal.dart';
import '../../../widgets/action/action_download_track.dart';
import '../../../widgets/list_tile_custom.dart';
import '../../../widgets/play_control/play_button.dart';

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({Key? key, required this.albumId}) : super(key: key);
  final int albumId;

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

//TODO: play track index of album
class _AlbumDetailState extends State<AlbumDetail> {
  final ScrollController _scrollController = ScrollController();
  late bool isShow = false;
  late bool isCheckScrollExtendAfter = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<AlbumViewModel>(context, listen: false)
      ..fetchAlbumById(widget.albumId)
      ..fetchTracksByAlbumId(widget.albumId);

    setIsLoading();
    _scrollController.addListener(_onScrollEvent);
  }

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 2000));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildAlbumDetailBody(context),
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

  Widget buildAlbumDetailBody(BuildContext context) {
    return Consumer<AlbumViewModel>(
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
            Album? album = value.albumDetail.data;
            List<Track>? tracks = value.tracks.data;
            if (album != null && tracks != null) {
              return Stack(children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    buildAppBar(value, context, album),
                    buildSelectionTitle(context, album),
                    SliverToBoxAdapter(
                      child: actions(tracks, album , value),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return playlistTile(context, tracks[index], album);
                        },
                        childCount: tracks.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                CommonUtils.formatReleaseDate(
                                    album.releaseDate.toString()),
                                style: Theme.of(context).textTheme.titleMedium),
                            paddingHeight(1.5),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      album.artist!.pictureSmall.toString()),
                                  radius: 20,
                                ),
                                paddingWidth(1.5),
                                Text(album.artist!.name.toString(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium)
                              ],
                            ),
                            paddingHeight(5),
                          ],
                        ),
                      ),
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
                          child: actions(tracks, album, value))),
                }
              ]);
            }
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          case Status.ERROR:
            return Text(value.tracks.toString());
          default:
            return const Text('Default Switch');
        }
      },
    );
  }

  SliverToBoxAdapter buildSelectionTitle(BuildContext context, Album album) {
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
                    album.artist!.pictureSmall.toString(),
                  ),
                ),
                const SizedBox(width: defaultPadding / 2),
                Text(
                  album.artist!.name.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
                'Album • ${CommonUtils.getYearByReleaseDate(album.releaseDate.toString())}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(
      AlbumViewModel value, BuildContext context, Album album) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: CachedNetworkImageProvider(album.coverXl.toString()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row actions(List<Track> tracks, Album album, AlbumViewModel value) {
    return Row(
      children: [
        StreamBuilder(
            stream: FavoriteAlbumService.instance
                .getAlbumItemsByUserId(userId: CommonUtils.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return IconButton(
                  onPressed: () {},
                  icon: const Icon(Ionicons.heart_outline),
                );
              }
              final isAddedFavoriteAlbum = snapshot.data!
                  .any((element) => element.albumId == album.id.toString());

              return isAddedFavoriteAlbum
                  ? IconButton(
                      onPressed: () {
                        ToastCommon.showCustomText(
                            content:
                                'Removed album ${album.title} from the library');
                        FavoriteAlbumService.instance.deleteItemByAlbumId(
                            album.id.toString(), CommonUtils.userId);
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
                                'Added album ${album.title} to the library');
                        FavoriteAlbumService.instance.addItem(
                          FavoriteAlbum(
                            id: DateTime.now().toString(),
                            albumId: album.id.toString(),
                            title: album.title,
                            artistName: album.artist!.name,
                            coverMedium: album.coverMedium,
                            userId: CommonUtils.userId,
                          ),
                        );
                      },
                      icon: const Icon(Ionicons.heart_outline));
            }),
        ActionDownloadTracks(
          album: album,
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
          album: album,
          artist: album.artist,
          albumId: album.id,
        ),
        const SizedBox(width: defaultPadding)
      ],
    );
  }

  Widget playlistTile(BuildContext context, Track track, Album album) {
    return Consumer<DownloadViewModel>(
      builder: (context, value, child) {
        final bool isDownloaded =
            value.trackDownloads.any((item) => item.id == track.id!);
        return TrackTileItem(
          track: track,
          album: album,
          isDownloaded: isDownloaded,
        );
        /*return Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: defaultPadding),
          child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    track.title as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Row(
                    children: [
                      isDownloaded
                          ? Row(
                              children: [
                                const Icon(Ionicons.arrow_down_circle_outline,
                                    color: Colors.deepPurple),
                                paddingWidth(0.5),
                              ],
                            )
                          : const SizedBox(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 1),
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              trailing: ActionMore(
                track: track,
                album: album,
                isDownloaded: isDownloaded,
                isAddedFavorite: false,
              )),
        );*/
      },
    );
  }
}
