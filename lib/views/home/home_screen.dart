import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/firebase/recent_played.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:demo_spotify_app/views/home/detail/playlist_detail.dart';
import 'package:demo_spotify_app/views/home/view/playlists_view.dart';
import 'package:demo_spotify_app/widgets/navigator/no_animation_page_route.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/default_constant.dart';
import '../../view_models/download_view_modal.dart';
import '../../view_models/home/home_view_model.dart';
import 'view/albums_view.dart';
import 'view/artists_view.dart';
import 'view/tracks_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    Provider.of<DownloadViewModel>(context, listen: false).loadTrackDownload();
    Provider.of<HomeViewModel>(context, listen: false)
      ..fetchChartPlaylistsApi()
      ..fetchChartAlbumsApi()
      ..fetchChartTracksApi()
      ..fetchChartArtistsApi();
    Provider.of<SignInViewModel>(context, listen: false).fetchLogin();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = DateTime.now();
          ToastCommon.showCustomText(content: 'Nhấn lần nữa để thoát');
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Consumer<HomeViewModel>(
          builder: (context, value, child) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        paddingHeight(1),
                        headerBody(),
                        buildHomeRecentPlayed(),
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildHomeRecentPlayed() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      margin: const EdgeInsets.only(top: defaultPadding),
      child: SizedBox(
        height: 70 * 3,
        child: GridView.builder(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: RecentPlayed.recentPlayed.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 60,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () => NavigatorPage.defaultLayoutPageRoute(
                context,
                PlaylistDetail(
                    playlistId: int.parse(
                        RecentPlayed.recentPlayed[index].id.toString()))),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(defaultBorderRadius / 2)),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(defaultBorderRadius / 2),
                          bottomLeft: Radius.circular(defaultBorderRadius / 2)),
                      child: CachedNetworkImage(
                        imageUrl:
                            RecentPlayed.recentPlayed[index].picture.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  paddingWidth(0.3),
                  Expanded(
                    child: Text(
                      RecentPlayed.recentPlayed[index].title.toString(),
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget headerBody() {
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
        ],
      ),
    );
  }
}
