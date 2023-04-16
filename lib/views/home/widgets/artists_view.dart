import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/views/home/components/card_item_custom.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/artist.dart';
import '../components/selection_title.dart';
import '../detail/artist_detail.dart';

class ArtistListView extends StatelessWidget {
  const ArtistListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'Suggested artists'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
            switch (value.chartArtists.status) {
              case Status.LOADING:
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
                  ),
                );
              case Status.COMPLETED:
                List<Artist>? artists = value.chartArtists.data;
                artists = artists!.reversed.toList();
                return SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: value.chartArtists.data!.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return CardItemCustom(
                          image: artists![index].pictureMedium as String,
                          titleTop: artists[index].name,
                          isCircle: true,
                          centerTitle: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation1,
                                    Animation<double> animation2) {
                                  return LayoutScreen(
                                    index: 4,
                                    screen:
                                        ArtistDetail(artistId: artists![index].id as int),
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
                return Text(value.chartArtists.toString());
              default:
                return const Text('Default Switch');
            }
          },
        )
      ],
    );
  }
}
