import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/views/home/components/card_item_custom.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/track.dart';
import '../../../view_models/multi_control_player_view_model.dart';
import '../../../view_models/track_play_view_model.dart';
import '../components/selection_title.dart';

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
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 40,
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
                            albumID: tracks[index].album!.id as int,
                            index: 0,
                            limit: 20,
                          );
                          int? trackIndex = trackPlayVM.tracksPlayControl.data!
                              .indexWhere(
                                  (track) => track.id == tracks[index].id);
                          await multiPlayerVM.initState(
                              tracks: trackPlayVM.tracksPlayControl.data!,
                              albumId: tracks[index].album!.id as int,
                              artist: tracks[index].artist,
                              index: trackIndex);
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