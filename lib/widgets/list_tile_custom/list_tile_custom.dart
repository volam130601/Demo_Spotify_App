import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/firebase/playlist_new.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';

import '../../data/network/firebase/playlist_new_service.dart';
import '../../models/album.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../utils/constants/default_constant.dart';
import '../../views/home/detail/album_detail.dart';
import '../../views/home/detail/playlist_detail.dart';
import '../../views/layout/layout_screen.dart';
import '../../views/library/add_playlist_detail_screen.dart';

class PlaylistTileItem extends StatelessWidget {
  const PlaylistTileItem({Key? key, required this.playlist}) : super(key: key);
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return LayoutScreen(
                index: 4,
                screen: PlaylistDetail(
                  playlistId: playlist.id!,
                ),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        height: 50,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
              child: SizedBox(
                width: 50,
                height: 50,
                child: CachedNetworkImage(
                  imageUrl: playlist.pictureMedium.toString(),
                  placeholder: (context, url) => Image.asset(
                    'assets/images/music_default.jpg',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            paddingWidth(0.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    playlist.title.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                          (playlist.user != null)
                              ? playlist.user!.name.toString()
                              : playlist.creator!.name.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumTileItem extends StatelessWidget {
  const AlbumTileItem({Key? key, required this.album}) : super(key: key);
  final Album album;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return LayoutScreen(
                index: 4,
                screen: AlbumDetail(
                  albumId: album.id!,
                ),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        height: 50,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
              child: SizedBox(
                width: 50,
                height: 50,
                child: CachedNetworkImage(
                  imageUrl: album.coverMedium.toString(),
                  placeholder: (context, url) => Image.asset(
                    'assets/images/music_default.jpg',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            paddingWidth(0.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    album.title.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(album.artist!.name.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistNewTileItem extends StatelessWidget {
  const PlaylistNewTileItem({Key? key, required this.playlistNew})
      : super(key: key);
  final PlaylistNew playlistNew;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return LayoutScreen(
                index: 4,
                screen: AddPlaylistDetailScreen(
                  playlistNew: playlistNew,
                ),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        height: 50,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
              child: SizedBox(
                width: 50,
                height: 50,
                child: (playlistNew.picture != null)
                    ? CachedNetworkImage(
                        imageUrl: playlistNew.picture.toString(),
                        placeholder: (context, url) => Image.asset(
                          'assets/images/music_default.jpg',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/music_default.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            paddingWidth(0.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    playlistNew.title.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(playlistNew.userName.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTrackToPlaylistTileItem extends StatelessWidget {
  const AddTrackToPlaylistTileItem(
      {Key? key, required this.playlistNew, required this.track})
      : super(key: key);
  final PlaylistNew playlistNew;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        List<Track> tracks = playlistNew.tracks!;
        tracks.add(track);
        PlaylistNewService.instance.updateItem(PlaylistNew(
          id: playlistNew.id,
          title: playlistNew.title,
          isDownloading: playlistNew.isDownloading,
          isPrivate: playlistNew.isDownloading,
          picture: tracks.first.album!.coverMedium,
          releaseDate: playlistNew.releaseDate,
          userId: playlistNew.userId,
          tracks: tracks,
          userName: playlistNew.userName,
        ));
        ToastCommon.showCustomText(
            content:
                'Add track ${track.title} to playlist ${playlistNew.title} is success!');
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        height: 50,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
              child: SizedBox(
                width: 50,
                height: 50,
                child: (playlistNew.picture != null)
                    ? CachedNetworkImage(
                        imageUrl: playlistNew.picture.toString(),
                        placeholder: (context, url) => Image.asset(
                          'assets/images/music_default.jpg',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/music_default.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            paddingWidth(0.5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    playlistNew.title.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(playlistNew.userName.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
