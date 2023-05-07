import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/response/status.dart';
import '../../../../models/album.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../../../view_models/home/artist_view_model.dart';
import '../../../../widgets/selection_title.dart';

class AlbumPopularRelease extends StatelessWidget {
  const AlbumPopularRelease({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewModel>(
      builder: (context, value, _) {
        switch (value.albumList.status) {
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
            List<Album>? albums = value.albumList.data;
            if (albums!.isNotEmpty) {
              albums.sort((a, b) => b.fans!.compareTo(a.fans as num));
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SelectionTitle(title: 'Popular releases'),
                    SizedBox(
                      height: 70 * (albums.length.toDouble() + 1),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final formatter = NumberFormat('#,###');
                          String numberFans =
                          formatter.format(albums[index].fans! * 100);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            margin:
                            const EdgeInsets.only(bottom: defaultPadding),
                            height: 70,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    albums[index].coverSmall as String,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/music_default.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: defaultPadding),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        albums[index].title as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        numberFans,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: albums.length,
                      ),
                    ),
                    Center(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder()),
                        child: Text(
                          'See discography',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                        ),
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
            return SliverToBoxAdapter(
              child: Text(value.albumList.toString()),
            );
          default:
            return const Text('Default Switch');
        }
      },
    );
  }
}
