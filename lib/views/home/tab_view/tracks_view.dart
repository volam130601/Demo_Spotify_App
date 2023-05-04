import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/widgets/card_item_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/response/status.dart';
import '../../../models/track.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../view_models/track_play/multi_control_player_view_model.dart';
import '../../../view_models/track_play_view_model.dart';
import '../../../widgets/navigator/slide_animation_page_route.dart';
import '../../../widgets/selection_title.dart';
import '../../play_control/track_play.dart';

class TrackListView extends StatelessWidget {
  const TrackListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'Recommended for today'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
            switch (value.chartTracks.status) {
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
                List<Track>? tracks = value.chartTracks.data;
                return SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tracks!.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return CardItemCustom(
                        image: tracks[index].album!.coverMedium as String,
                        titleTop: tracks[index].title,
                        titleBottom: tracks[index].artist!.name,
                        centerTitle: false,
                        onTap: () async {
                          var trackPlayVM = Provider.of<TrackPlayViewModel>(
                              context,
                              listen: false);
                          var multiPlayerVM = Provider.of<MultiPlayerViewModel>(
                              context,
                              listen: false);
                          await trackPlayVM.fetchTracksPlayControl(
                            albumID: tracks[index].album!.id!,
                          );
                          int? trackIndex = trackPlayVM.tracksPlayControl.data!
                              .indexWhere(
                                  (track) => track.id == tracks[index].id);
                          await multiPlayerVM.initState(
                              tracks: trackPlayVM.tracksPlayControl.data!,
                              albumId: tracks[index].album!.id as int,
                              album: tracks[index].album,
                              artist: tracks[index].artist,
                              index: trackIndex);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context)
                              .push(SlideTopPageRoute(page: const TrackPlay()));
                        },
                      );
                    },
                  ),
                );
              case Status.ERROR:
                return Text(value.chartTracks.toString());
              default:
                return const Text('Default Switch');
            }
          },
        )
      ],
    );
  }
}
