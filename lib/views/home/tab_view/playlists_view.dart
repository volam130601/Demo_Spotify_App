import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/view_models/home/home_view_model.dart';
import 'package:demo_spotify_app/views/layout/layout_screen.dart';
import 'package:demo_spotify_app/widgets/card_item_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/response/status.dart';
import '../../../view_models/playlist_view_model.dart';
import '../../../widgets/selection_title.dart';
import '../detail/playlist_detail.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'To get you started'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
            switch (value.chartPlaylists.status) {
              case Status.LOADING:
                return SizedBox(
                  height: 200,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade600,
                    highlightColor: Colors.grey.shade500,
                    enabled: true,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, __) => Container(
                        height: 150,
                        width: 150,
                        color: Colors.grey.shade700,
                        margin: const EdgeInsets.only(left: defaultPadding),
                      ),
                      itemCount: 6,
                    ),
                  ),
                );
              case Status.COMPLETED:
                List<Playlist>? playlists =
                    value.chartPlaylists.data?.cast<Playlist>();
                return SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: value.chartPlaylists.data!.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return CardItemCustom(
                        image: playlists![index].pictureXl as String,
                        titleTop: playlists[index].title,
                        titleBottom: playlists[index].user!.name,
                        centerTitle: false,
                        onTap: () {
                          Provider.of<PlaylistViewModel>(context, listen: false)
                              .fetchTotalSizeDownload(
                                  playlists[index].id!, 0, 10000);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation1,
                                  Animation<double> animation2) {
                                return LayoutScreen(
                                  index: 4,
                                  screen: PlaylistDetail(
                                    playlistId: playlists[index].id!,
                                  ),
                                );
                              },
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              case Status.ERROR:
                return Text(value.chartPlaylists.toString());
              default:
                return const Text('Default Switch');
            }
          },
        )
      ],
    );
  }
}
