import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/views/home/components/card_item_custom.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/album.dart';
import '../components/selection_title.dart';
import '../detail/album_detail.dart';

class AlbumListView extends StatelessWidget {
  const AlbumListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'Try something else'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
            switch (value.chartAlbums.status) {
              case Status.LOADING:
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
                  ),
                );
              case Status.COMPLETED:
                List<Album>? albums = value.chartAlbums.data;
                return SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: albums!.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return CardItemCustom(
                          image: albums[index].coverMedium as String,
                          titleTop: albums[index].artist!.name,
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
                                    screen: AlbumDetail(
                                      album: albums[index],
                                    ),
                                  );
                                },
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                        );
                      }),
                );
              case Status.ERROR:
                return Text(value.chartAlbums.toString());
              default:
                return const Text('Default Switch');
            }
          },
        )
      ],
    );
  }
}
