import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:demo_spotify_app/widgets/action/modal_add_playlist.dart';
import 'package:demo_spotify_app/widgets/action/modal_download_track.dart';
import 'package:demo_spotify_app/widgets/navigator/no_animation_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../models/track.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../models/album.dart';
import '../../models/firebase/playlist_new.dart';
import '../../models/playlist.dart';
import '../../repository/remote/firebase/favorite_song_repository.dart';
import '../../repository/remote/firebase/playlist_new_repository.dart';
import '../../utils/colors.dart';
import '../../views/home/detail/album_detail.dart';
import '../../views/home/detail/artist/artist_detail.dart';
import '../../views/library/add_playlist.dart';
import '../list_tile_custom/list_tile_custom.dart';

class ActionMore extends StatefulWidget {
  const ActionMore({
    Key? key,
    required this.track,
    this.playlist,
    this.album,
    this.playlistNew,
  }) : super(key: key);
  final Track track;
  final Playlist? playlist;
  final Album? album;
  final PlaylistNew? playlistNew;

  @override
  State<ActionMore> createState() => _ActionMoreState();
}

class _ActionMoreState extends State<ActionMore> {

  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    IsolateNameServer.lookupPortByName('downloader_track')
        ?.send([id, status.value, progress]);
  }

  @override
  Widget build(BuildContext context) {
    Track? track = widget.track;
    Widget addPlaylistTileItem;

    if (widget.playlistNew != null) {
      addPlaylistTileItem = buildModalTileItem(
        context,
        title: 'Remove from playlist',
        icon: Image.asset(
          'assets/icons/icons8-add-song-48.png',
          color: Colors.white,
          width: 20,
          height: 20,
        ),
        onTap: () {
          PlaylistNewRepository.instance.removePlaylistNewByTrackId(
              playlistNew: widget.playlistNew!, trackId: track.id!);
          Navigator.pop(context);
        },
      );
    } else {
      addPlaylistTileItem = ModalAddPlaylist(track: track);
    }

    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (widget.album != null) {
            buildShowModalMore(
                context, track, widget.album!, addPlaylistTileItem);
          } else {
            buildShowModalMore(
                context, track, track.album!, addPlaylistTileItem);
          }
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0)),
        child: const Icon(Icons.more_vert),
      ),
    );
  }


  Future<dynamic> buildShowModalMore(BuildContext context, Track track,
      Album album, Widget addPlaylistTileItem) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * .5,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(defaultBorderRadius),
              topRight: Radius.circular(defaultBorderRadius),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                paddingHeight(0.5),
                buildHeaderModal(context, track, album),
                buildDivider(),
                ModalDownloadTrack(
                    context: context, track: track, album: album),
                buildFavoriteTrackTile(),
                addPlaylistTileItem,
                buildModalTileItem(
                  context,
                  title: 'View Album',
                  icon: Image.asset(
                    'assets/icons/icons8-disk-24.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    NavigatorPage.defaultLayoutPageRoute(
                        context,
                        AlbumDetail(
                            albumId: (track.album != null)
                                ? track.album!.id!
                                : widget.album!.id!));
                  },
                ),
                buildModalTileItem(
                  context,
                  title: 'View Artist',
                  icon: Image.asset(
                    'assets/icons/icons8-artist-25.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    NavigatorPage.defaultLayoutPageRoute(
                        context, ArtistDetail(artistId: track.artist!.id!));
                  },
                ),
                paddingHeight(1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<FavoriteSong>> buildFavoriteTrackTile() {
    return StreamBuilder(
      stream: FavoriteSongRepository.instance.getFavoriteSongs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Row(
            children: [
              SizedBox(
                width: 50,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Ionicons.heart_outline),
                ),
              ),
            ],
          );
        }
        Track track = widget.track;
        final isAddedFavorite = snapshot.data!
            .any((element) => element.trackId == track.id.toString());
        if (isAddedFavorite == true) {
          return buildModalTileItem(
            context,
            title: 'Added to the library',
            icon: Icon(
              Icons.favorite,
              color: ColorsConsts.primaryColorDark,
            ),
            onTap: removeFavoriteTrack(track),
          );
        } else {
          return buildModalTileItem(
            context,
            title: 'Add to the library',
            icon: const Icon(Icons.favorite_border_sharp),
            onTap: addFavoriteTrack(track),
          );
        }
      },
    );
  }

  Padding buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: defaultPadding),
      child: Divider(
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget buildModalTileItem(BuildContext context,
      {String title = '', Widget? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: 60, child: icon),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  SizedBox buildHeaderModal(BuildContext context, Track track, Album album) {
    return SizedBox(
      height: 60,
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            child: CachedNetworkImage(
              imageUrl: '${album.coverMedium}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.asset(
                'assets/images/music_default.jpg',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        title: Text(
          '${track.title}',
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              '${track.artist!.name}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined),
        ),
      ),
    );
  }

  VoidCallback removeFavoriteTrack(Track track) {
    return () {
      ToastCommon.showCustomText(
          content: 'Removed track ${track.title} from the library');
      FavoriteSongRepository.instance
          .deleteFavoriteSongByTrackId(track.id.toString());
    };
  }

  VoidCallback addFavoriteTrack(Track track) {
    return () {
      ToastCommon.showCustomText(
          content: 'Added track ${track.title} to the library');
      if (widget.album != null) {
        FavoriteSongRepository.instance.addFavoriteSong(track, widget.album!);
      } else {
        FavoriteSongRepository.instance.addFavoriteSong(track, track.album!);
      }
    };
  }
}
