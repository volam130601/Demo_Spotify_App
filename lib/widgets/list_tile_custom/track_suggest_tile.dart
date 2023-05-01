import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/firebase/playlist_new.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../data/network/firebase/playlist_new_service.dart';
import '../../models/track.dart';
import '../../utils/constants/default_constant.dart';
import '../../view_models/layout_screen_view_model.dart';

class TrackSuggestTileItem extends StatelessWidget {
  const TrackSuggestTileItem(
      {Key? key, required this.track, required this.playlistNew})
      : super(key: key);
  final Track track;
  final PlaylistNew playlistNew;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
                  imageUrl: (track.album!.coverMedium != null)
                      ? track.album!.coverMedium.toString()
                      : 'https://i.pinimg.com/originals/53/5b/67/535b67003b977d408472cead625bb6f3.jpg',
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
                    track.title.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(track.artist!.name.toString(),
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
            SizedBox(
              width: 50,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
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
                  Navigator.pop(context);
                  Provider.of<LayoutScreenViewModel>(context, listen: false)
                      .setIsShotBottomBar(true);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0)),
                child: const Icon(Ionicons.add_circle_outline),
              ),
            )
          ],
        ),
      ),
    );
  }
}
