import 'package:demo_spotify_app/data/network/firebase/favorite_song_service.dart';
import 'package:demo_spotify_app/models/artist.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';
import 'package:demo_spotify_app/view_models/download_view_modal.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../models/album.dart';
import '../../models/track.dart';
import '../../utils/common_utils.dart';
import '../../utils/constants/default_constant.dart';
import '../../view_models/multi_control_player_view_model.dart';
import '../../widgets/container_null_value.dart';
import '../../widgets/list_tile_custom/track_tile_item.dart';
import '../../widgets/navigator/slide_animation_page_route.dart';
import '../home/play_control/track_play.dart';

class FavoriteSongScreen extends StatefulWidget {
  const FavoriteSongScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteSongScreen> createState() => _FavoriteSongScreenState();
}

class _FavoriteSongScreenState extends State<FavoriteSongScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setIsLoading();
  }

  void setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_sharp)),
        ],
      ),
      body: Stack(
        children: [
          const FavoriteSongBody(),
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
}

class FavoriteSongBody extends StatelessWidget {
  const FavoriteSongBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FavoriteSongService.instance.getItemsByUserId(CommonUtils.userId),
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
        List<FavoriteSong>? data = snapshot.data!.reversed.toList();
        List<Track>? tracks = [];
        for (var item in data) {
          tracks.add(
            Track(
              id: int.tryParse(item.trackId.toString()),
              title: item.title,
              artist: Artist(
                  id: int.tryParse(item.artistId.toString()),
                  name: item.artistName,
                  pictureMedium: item.pictureMedium),
              album: Album(
                  id: int.tryParse(item.albumId.toString()),
                  title: item.albumTitle,
                  artist: Artist(
                      name: item.artistName, pictureSmall: item.pictureMedium),
                  coverMedium: item.coverMedium,
                  coverXl: item.coverXl),
              preview: item.preview,
              type: item.type,
            ),
          );
        }
        if (data.isEmpty) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Favorite Song',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                paddingHeight(6),
                const ContainerNullValue(
                  image: 'assets/images/library/album_none.png',
                  title: 'You haven\'t liked any songs yet.',
                  subtitle:
                      'Find and click favorite songs to add to the library.',
                )
              ],
            ),
          );
        }
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Favorite Song',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${data.length} track • Saved to library',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                paddingHeight(2),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                          vertical: defaultPadding * 0.8)),
                  child: Text(
                    'PLAY MUSIC',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                paddingHeight(2),
                buildSelection(context),
                paddingHeight(1),
                buildListFavoriteSong(tracks),
                paddingHeight(8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildListFavoriteSong(List<Track> tracks) {
    return SizedBox(
      height: tracks.length * (50 + 16),
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => InkWell(
          onTap: () async {
            var multiPlayerVM =
                Provider.of<MultiPlayerViewModel>(context, listen: false);
            await multiPlayerVM.initState(
              tracks: tracks,
              index: index,
            );
            // ignore: use_build_context_synchronously
            Navigator.of(context)
                .push(SlideTopPageRoute(page: const TrackPlay()));
          },
          child: buildFavoriteSongTile(tracks, tracks[index], context),
        ),
        itemCount: tracks.length,
      ),
    );
  }

  Widget buildFavoriteSongTile(
      List<Track> tracks, Track track, BuildContext context) {
    return Consumer<DownloadViewModel>(
      builder: (context, value, child) {
        final bool isDownloaded =
            value.trackDownloads.any((item) => item.id == track.id!);
        return TrackTileItem(
          track: track,
          album: track.album,
          isDownloaded: isDownloaded,
        );
      },
    );
  }

  Padding buildSelection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Row(
            children: [
              const Icon(
                Ionicons.arrow_down_circle_outline,
                size: 30,
              ),
              paddingWidth(0.5),
              Text(
                'Download',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Ionicons.filter_circle_outline,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
