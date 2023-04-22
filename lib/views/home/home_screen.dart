import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/view_models/downloader/download_view_modal.dart';
import 'package:demo_spotify_app/views/home/widgets/albums_view.dart';
import 'package:demo_spotify_app/views/home/widgets/artists_view.dart';
import 'package:demo_spotify_app/views/home/widgets/playlists_view.dart';
import 'package:demo_spotify_app/views/home/widgets/tracks_view.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/default_constant.dart';
import '../../view_models/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setIsLoading();
    Provider.of<DownloadViewModel>(context, listen: false).loadTracksDownloaded();
    Provider.of<HomeViewModel>(context, listen: false)
      ..fetchChartPlaylistsApi()
      ..fetchChartAlbumsApi()
      ..fetchChartTracksApi()
      ..fetchChartArtistsApi();
  }

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 40,
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          bool confirmed = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Xác nhận'),
                content: const Text('Bạn có muốn thoát ứng dụng không?'),
                actions: [
                  TextButton(
                    child: const Text('Không'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text('Có'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          );
          return confirmed;
        },
        child: Scaffold(
          body: Consumer<HomeViewModel>(
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.only(top: defaultPadding),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      paddingHeight(1),
                      const HeaderBody(),
                      paddingHeight(1),
                      buildHomeRecentSearch(),
                      const PlaylistView(),
                      paddingHeight(2),
                      const AlbumListView(),
                      paddingHeight(2),
                      const TrackListView(),
                      paddingHeight(2),
                      const ArtistListView(),
                      paddingHeight(8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  Padding buildHomeRecentSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: SizedBox(
        height: (60 + 8) * 3,
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return paddingHeight(0.5);
          },
          padding: const EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius:
                          BorderRadius.circular(defaultBorderRadius / 2)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(defaultBorderRadius / 2),
                              bottomLeft:
                                  Radius.circular(defaultBorderRadius / 2)),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      paddingWidth(0.3),
                      Expanded(
                        child: Text(
                          'This is League of Legends',
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              paddingWidth(0.5),
              Expanded(
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius:
                          BorderRadius.circular(defaultBorderRadius / 2)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(defaultBorderRadius / 2),
                              bottomLeft:
                                  Radius.circular(defaultBorderRadius / 2)),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      paddingWidth(0.3),
                      Expanded(
                        child: Text(
                          'This is League of Legends',
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          itemCount: 3,
        ),
      ),
    );
  }
}

class HeaderBody extends StatelessWidget {
  const HeaderBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Text(
            'Good morning',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(FeatherIcons.bell)),
          IconButton(
              onPressed: () {}, icon: const Icon(Ionicons.timer_outline)),
          IconButton(
              onPressed: () {}, icon: const Icon(Ionicons.settings_outline)),
        ],
      ),
    );
  }
}
