import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:demo_spotify_app/views/search/search_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../models/album.dart';
import '../../models/artist.dart';
import '../../models/firebase/recent_search.dart';
import '../../models/playlist.dart';
import '../../repository/remote/firebase/recent_search_repository.dart';
import '../../utils/colors.dart';
import '../../utils/constants/default_constant.dart';
import '../../view_models/track_play/multi_control_player_view_model.dart';
import '../../view_models/track_play/track_play_view_model.dart';
import '../home/detail/album_detail.dart';
import '../home/detail/artist/artist_detail.dart';
import '../home/detail/playlist_detail.dart';
import '../layout/layout_screen.dart';

class RecentSearch extends StatefulWidget {
  const RecentSearch({Key? key}) : super(key: key);

  @override
  State<RecentSearch> createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {
  bool? isClear = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RecentSearchItem>>(
      stream: RecentSearchRepository.instance
          .getItemsByUserId(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }

        List<RecentSearchItem>? data = snapshot.data!.reversed.toList();
        if (data.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Play what you love',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Search for artists, songs, albums, and more.',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: defaultPadding, bottom: defaultPadding),
              child: Text(
                'Recent searches',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(
              height: (data.length > 9)
                  ? MediaQuery.of(context).size.height - 350
                  : ((data.length) * 60),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return buildRecentSearchItem(
                        context, data[index], (data.first.id == data.last.id));
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: TextButton(
                onPressed: () {
                  RecentSearchRepository.instance.deleteAll();
                },
                child: Text(
                  'Clear recent searches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorsConsts.primaryColorDark,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            paddingHeight(6),
          ],
        );
      },
    );
  }

  Widget buildRecentSearchItem(
      BuildContext context, RecentSearchItem item, bool checkData) {
    VoidCallback? onTap;
    if (item.type == 'track') {
      onTap = () async {
        var trackPlayVM =
            Provider.of<TrackPlayViewModel>(context, listen: false);
        var multiPlayerVM =
            Provider.of<MultiPlayerViewModel>(context, listen: false);
        hideKeyboard(context);
        await trackPlayVM.fetchTracksPlayControl(
          albumID: item.albumSearch!.id as int,
          index: 0,
          limit: 20,
        );

        int? trackIndex = trackPlayVM.tracksPlayControl.data!
            .indexWhere((track) => (track.id == int.parse(item.itemId!)));
        Artist? artist = Artist(
            id: item.artistSearch!.id,
            name: item.artistSearch!.name,
            pictureSmall: item.artistSearch!.pictureSmall);

        await multiPlayerVM.initState(
            tracks: trackPlayVM.tracksPlayControl.data!,
            albumId: item.albumSearch!.id as int,
            album: Album(
              id: item.albumSearch!.id,
              title: item.albumSearch!.title,
              coverMedium: item.albumSearch!.coverMedium,
              coverXl: item.albumSearch!.coverXl,
            ),
            artist: artist,
            index: trackIndex);
      };
    } else if (item.type == 'artist') {
      onTap = () {
        hideKeyboard(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return LayoutScreen(
                index: 4,
                screen: ArtistDetail(artistId: int.parse(item.itemId!)),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      };
    } else if (item.type == 'playlist') {
      onTap = () {
        hideKeyboard(context);
        Playlist? playlist = Playlist(
          id: item.playlistSearch!.id,
          title: item.playlistSearch!.title,
          pictureMedium: item.playlistSearch!.pictureMedium,
          pictureXl: item.playlistSearch!.pictureXl,
        );
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return LayoutScreen(
                index: 4,
                screen: PlaylistDetail(
                  playlistId: playlist.id!,
                  userName: item.playlistSearch!.userName,
                ),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      };
    } else if (item.type == 'album') {
      onTap = () {
        hideKeyboard(context);
        Album? album = Album(
            id: int.parse(item.itemId!),
            title: item.title,
            coverXl: item.albumSearch!.coverXl);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return LayoutScreen(
                index: 4,
                screen: AlbumDetail(albumId: album.id!),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      };
    }
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: ListTile(
          leading: SizedBox(
            height: 50,
            width: 50,
            child: CachedNetworkImage(
              imageUrl: item.image!,
              placeholder: (context, url) => Image.asset(
                'assets/images/music_default.jpg',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          title: Container(
            margin: const EdgeInsets.only(bottom: defaultPadding / 2),
            child: Text(
              item.title!,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text(
            item.type!,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () {
              if (checkData) {
                setState(() {
                  isClear = true;
                });
              }
              RecentSearchRepository.instance.deleteRecentSearch(item.id!);
              ToastCommon.showCustomText(
                  content: 'Remove recent search is success');
            },
            icon: const Icon(Ionicons.close),
          ),
        ),
      ),
    );
  }
}
