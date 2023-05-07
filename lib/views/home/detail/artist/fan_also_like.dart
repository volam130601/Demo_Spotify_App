import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/response/status.dart';
import '../../../../models/artist.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../../../view_models/home/artist_view_model.dart';
import '../../../../widgets/selection_title.dart';
import '../../../layout/layout_screen.dart';
import 'artist_detail.dart';

class FanAlsoLike extends StatelessWidget {
  const FanAlsoLike({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewModel>(
      builder: (context, value, _) {
        switch (value.artistList.status) {
          case Status.LOADING:
            return SliverToBoxAdapter(
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          case Status.COMPLETED:
            List<Artist>? artists = value.artistList.data;
            if (artists!.isNotEmpty) {
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SelectionTitle(title: 'Fans also like'),
                    SizedBox(
                      height: 180.0,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.horizontal,
                        itemCount: artists.length,
                        itemBuilder: (context, index) {
                          return buildCardArtist(artists, index, context,value);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SliverToBoxAdapter(
                child: SizedBox(),
              );
            }
          case Status.ERROR:
            return SliverToBoxAdapter(child: Text(value.artistList.toString()));
          default:
            return const Text('Default Switch');
        }
      },
    );
  }

  Widget buildCardArtist(
      List<Artist> artists, int index, BuildContext context, ArtistViewModel value) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return LayoutScreen(
                index: 4,
                screen: ArtistDetail(artistId: artists[index].id as int),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(left: defaultPadding),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: CachedNetworkImageProvider(
                  artists[index].pictureMedium as String),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                artists[index].name as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
