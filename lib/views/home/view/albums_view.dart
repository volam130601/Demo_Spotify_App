import 'package:demo_spotify_app/view_models/home/home_view_model.dart';
import 'package:demo_spotify_app/views/layout/layout_screen.dart';
import 'package:demo_spotify_app/widgets/card_item_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/response/status.dart';
import '../../../models/album.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../widgets/selection_title.dart';
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
                return SizedBox(
                  height: 100,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade600,
                    highlightColor: Colors.grey.shade500,
                    enabled: true,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, __) => Container(
                        height: 250,
                        width: 150,
                        color: Colors.grey.shade700,
                        margin: const EdgeInsets.only(left: defaultPadding),
                      ),
                      itemCount: 6,
                    ),
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
                          image: albums[index].coverMedium.toString(),
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
                                      albumId: albums[index].id!,
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
