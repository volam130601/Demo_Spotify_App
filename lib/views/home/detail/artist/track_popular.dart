import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/response/status.dart';
import '../../../../models/artist.dart';
import '../../../../models/track.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../../../view_models/home/artist_view_model.dart';
import '../../../../view_models/track_play/multi_control_player_view_model.dart';
import '../../../../widgets/selection_title.dart';

List<Color> colorTrackPopulars = [
  Colors.white,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.deepPurple,
];

List<String> trackFans = [
  '15,254,001',
  '10,222,061',
  '5,632,123',
  '4,000,231',
  '3,331,103',
];

class TrackPopular extends StatelessWidget {
  const TrackPopular({Key? key, required this.artist}) : super(key: key);
  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewModel>(
      builder: (context, value, _) {
        switch (value.trackList.status) {
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
            List<Track>? tracks = value.trackList.data;
            if (tracks!.isNotEmpty) {
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SelectionTitle(title: 'Popular'),
                    SizedBox(
                      height: (tracks.length < 5)
                          ? (60 * tracks.length.toDouble())
                          : (60 * 5),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            var value = Provider.of<MultiPlayerViewModel>(
                                context,
                                listen: false);
                            value.initState(
                                tracks: tracks,
                                artist: artist,
                                artistId: artist.id,
                                index: index);
                          },
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: colorTrackPopulars[index],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CachedNetworkImage(
                                    imageUrl: tracks[index].album!.coverSmall
                                        as String,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/images/music_default.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: defaultPadding / 2),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tracks[index].title as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        trackFans[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_vert,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        itemCount: tracks.length < 5 ? tracks.length : 5,
                      ),
                    )
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
              child: Text(value.trackList.toString()),
            );
          default:
            return const Text('Default Switch');
        }
      },
    );
  }
}
