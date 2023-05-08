import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/response/status.dart';
import '../../../../models/artist.dart';
import '../../../../models/playlist.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../../../view_models/home/artist_view_model.dart';
import '../../../../view_models/home/playlist_view_model.dart';
import '../../../../widgets/selection_title.dart';
import '../../../layout/layout_screen.dart';
import '../playlist_detail.dart';

class FeaturingPlaylistOfArtist extends StatelessWidget {
  const FeaturingPlaylistOfArtist({Key? key, required this.artist})
      : super(key: key);
  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewModel>(
      builder: (context, value, _) {
        switch (value.playlistList.status) {
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
            List<Playlist>? playlists = value.playlistList.data;
            if (playlists!.isNotEmpty) {
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectionTitle(title: 'Featuring ${artist.name}'),
                    SizedBox(
                      height: 180.0,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.horizontal,
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return buildCardPlaylist(playlists, index, context);
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SliverToBoxAdapter(child: SizedBox());
            }
          case Status.ERROR:
            return SliverToBoxAdapter(
              child: Text(value.playlistList.toString()),
            );
          default:
            return const Text('Default Switch');
        }
      },
    );
  }

  Widget buildCardPlaylist(
      List<Playlist> playlists, int index, BuildContext context) {
    return InkWell(
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
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(left: defaultPadding),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: playlists[index].pictureMedium as String,
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                playlists[index].title as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
