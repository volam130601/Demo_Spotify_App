import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/firebase/playlist_new.dart';
import 'package:demo_spotify_app/view_models/download_view_modal.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../models/album.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repository/remote/firebase/favorite_song_repository.dart';
import '../../utils/colors.dart';
import '../../utils/constants/default_constant.dart';
import '../../utils/toast_utils.dart';
import '../action/action_more.dart';

class TrackTileItem extends StatefulWidget {
  const TrackTileItem(
      {Key? key,
      required this.track,
      this.isDownloaded = false,
      this.playlist,
      this.album,
      this.playlistNew})
      : super(key: key);
  final Track track;
  final bool isDownloaded;
  final PlaylistNew? playlistNew;
  final Playlist? playlist;
  final Album? album;

  @override
  State<TrackTileItem> createState() => _TrackTileItemState();
}

class _TrackTileItemState extends State<TrackTileItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                imageUrl: (widget.album != null)
                    ? '${widget.album!.coverMedium}'
                    : widget.track.album!.coverMedium.toString(),
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
                    Selector<DownloadViewModel, bool>(
                      selector: (context, viewModel) {
                        final bool isDownloaded = viewModel.trackDownloads
                            .any((item) => item.id == widget.track.id!);
                        return isDownloaded;
                      },
                      builder: (context, isDownloaded, child) {
                        if (isDownloaded == true) {
                          return Row(
                            children: [
                              const Icon(Ionicons.arrow_down_circle_outline,
                                  color: Colors.deepPurple),
                              paddingWidth(0.5),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    Expanded(
                      child: Text(widget.track.artist!.name.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildButtonFavoriteSong(),
          ActionMore(
            track: widget.track,
            playlist: widget.playlist,
            album: widget.album,
            playlistNew:
                (widget.playlistNew != null) ? widget.playlistNew : null,
          ),
        ],
      ),
    );
  }

  Widget buildButtonFavoriteSong() {
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
        return SizedBox(
          width: 50,
          child: isAddedFavorite
              ? IconButton(
                  onPressed: removeFavoriteTrack(track),
                  icon: Icon(
                    Ionicons.heart,
                    color: ColorsConsts.primaryColorDark,
                  ),
                )
              : IconButton(
                  onPressed: addFavoriteTrack(track),
                  icon: const Icon(Ionicons.heart_outline)),
        );
      },
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
