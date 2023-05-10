import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/view_models/home/album_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/album.dart';
import '../../../repository/remote/firebase/favorite_album_service.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../utils/toast_utils.dart';
import '../../../view_models/track_play/multi_control_player_view_model.dart';
import '../../../widgets/action/action_download_multi_tracks.dart';
import '../../../widgets/list_tile_custom/track_tile_item.dart';
import '../../../widgets/play_control/play_button.dart';

class AlbumDetail extends StatefulWidget {
  const AlbumDetail({Key? key, required this.albumId}) : super(key: key);
  final int albumId;

  @override
  State<AlbumDetail> createState() => _AlbumDetailState();
}

class _AlbumDetailState extends State<AlbumDetail> {
  final ScrollController _scrollController = ScrollController();
  late bool isShow = false;
  late bool isCheckScrollExtendAfter = false;

  @override
  void initState() {
    super.initState();

    Provider.of<AlbumViewModel>(context, listen: false)
      ..fetchAlbumById(widget.albumId)
      ..fetchTracksByAlbumId(widget.albumId);

    _scrollController.addListener(_onScrollEvent);
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
      body: Consumer<AlbumViewModel>(
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
                        child: actions(tracks, album, value),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return InkWell(
                              child: TrackTileItem(
                                  track: tracks[index], album: album),
                              onTap: () {
                                var value = Provider.of<MultiPlayerViewModel>(
                                    context,
                                    listen: false);
                                int? currentAlbumId = widget.albumId;
                                if (currentAlbumId != value.getAlbumId) {
                                  value.initState(
                                      tracks: tracks,
                                      album: album,
                                      artist: album.artist,
                                      albumId: album.id,
                                      index: index);
                                } else {
                                  value.player
                                      .seek(Duration.zero, index: index);
                                }
                              },
                            );
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium)
                                ],
                              ),
                              paddingHeight(5),
                            ],
                          ),
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
      ),
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
            stream: FavoriteAlbumRepository.instance.getAlbumItemsByUserId(
                userId: FirebaseAuth.instance.currentUser!.uid),
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
                        FavoriteAlbumRepository.instance
                            .deleteFavoriteAlbumByAlbumId(album.id.toString(),
                                FirebaseAuth.instance.currentUser!.uid);
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
                        FavoriteAlbumRepository.instance
                            .addFavoriteAlbum(album: album);
                      },
                      icon: const Icon(Ionicons.heart_outline));
            }),
        ActionDownloadTracks(
          album: album,
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
          album: album,
          artist: album.artist,
          albumId: album.id,
        ),
        const SizedBox(width: defaultPadding)
      ],
    );
  }
}
