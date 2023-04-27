import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../data/network/firebase/favorite_song_service.dart';
import '../models/album.dart';
import '../models/firebase/favorite_song.dart';
import '../models/playlist.dart';
import '../models/track.dart';
import '../utils/colors.dart';
import '../utils/constants/default_constant.dart';
import '../utils/toast_utils.dart';
import 'action/action_more.dart';

class TrackTileItem extends StatefulWidget {
  const TrackTileItem(
      {Key? key,
      required this.track,
      this.isDownloaded = false,
      this.playlist,
      this.album})
      : super(key: key);
  final Track track;
  final bool isDownloaded;
  final Playlist? playlist;
  final Album? album;

  @override
  State<TrackTileItem> createState() => _TrackTileItemState();
}

class _TrackTileItemState extends State<TrackTileItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: defaultPadding),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      height: 50,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
            child: SizedBox(
              width: 50,
              height: 50,
              child: CachedNetworkImage(
                imageUrl: widget.track.album!.coverMedium.toString(),
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
                  widget.track.title.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    widget.isDownloaded
                        ? Row(
                            children: [
                              const Icon(Ionicons.arrow_down_circle_outline,
                                  color: Colors.deepPurple),
                              paddingWidth(0.5),
                            ],
                          )
                        : const SizedBox(),
                    Text(widget.track.artist!.name.toString(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
          buildButtonFavoriteSong(),
        ],
      ),
    );
  }

  Widget buildButtonFavoriteSong() {
    return StreamBuilder(
      stream: FavoriteSongService.instance
          .getItemsByUserId(FirebaseAuth.instance.currentUser!.uid),
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
              (widget.playlist != null)
                  ? ActionMore(
                      track: widget.track,
                      playlist: widget.playlist,
                      isDownloaded: widget.isDownloaded,
                      isAddedFavorite: false,
                    )
                  : ActionMore(
                      track: widget.track,
                      album: widget.album,
                      isDownloaded: widget.isDownloaded,
                      isAddedFavorite: false,
                    ),
            ],
          );
        }
        Track track = widget.track;
        final isAddedFavorite = snapshot.data!
            .any((element) => element.trackId == track.id.toString());
        return Row(
          children: [
            SizedBox(
              width: 50,
              child: isAddedFavorite
                  ? IconButton(
                      onPressed: () {
                        ToastCommon.showCustomText(
                            content:
                                'Removed track ${track.title} from the library');
                        FavoriteSongService.instance.deleteItemByTrackId(
                            track.id.toString(),
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
                                'Added track ${track.title} to the library');
                        FavoriteSongService.instance.addItem(
                          FavoriteSong(
                            id: DateTime.now().toString(),
                            trackId: track.id.toString(),
                            albumId: track.album!.id.toString(),
                            artistId: track.artist!.id.toString(),
                            title: track.title,
                            albumTitle: track.album!.title,
                            artistName: track.artist!.name,
                            pictureMedium: track.artist!.pictureMedium,
                            coverMedium: track.album!.coverMedium,
                            coverXl: track.album!.coverXl,
                            preview: track.preview,
                            releaseDate: track.album!.releaseDate,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            type: 'track',
                          ),
                        );
                      },
                      icon: const Icon(Ionicons.heart_outline)),
            ),
            (widget.playlist != null)
                ? ActionMore(
                    track: widget.track,
                    playlist: widget.playlist,
                    isDownloaded: widget.isDownloaded,
                    isAddedFavorite: isAddedFavorite,
                  )
                : ActionMore(
                    track: widget.track,
                    album: widget.album,
                    isDownloaded: widget.isDownloaded,
                    isAddedFavorite: isAddedFavorite,
                  ),
          ],
        );
      },
    );
  }
}

class PlaylistTileItem extends StatelessWidget {
  const PlaylistTileItem({Key? key, required this.playlist}) : super(key: key);
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: defaultPadding),
      margin: const EdgeInsets.only(bottom: defaultPadding),
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
