import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/widgets/card_item_custom.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
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
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
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
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation1,
                                  Animation<double> animation2) {
                                return LayoutScreen(
                                  index: 4,
                                  screen: PlaylistDetail(
                                    playlist: playlists[index],
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
