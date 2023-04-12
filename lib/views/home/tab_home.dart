import 'package:demo_spotify_app/models/album.dart';
import 'package:demo_spotify_app/models/artist.dart';
import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/views/home/components/card_item_custom.dart';
import 'package:demo_spotify_app/views/home/detail/artist_detail.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/track.dart';
import '../../view_models/multi_control_player_view_model.dart';
import '../../view_models/track_play_view_model.dart';
import 'components/selection_title.dart';
import 'detail/album_detail.dart';
import 'detail/playlist_detail.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'To get you started'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
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
          },
        )
      ],
    );
  }
}

class AlbumLists extends StatelessWidget {
  const AlbumLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'Try something else'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
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
          },
        )
      ],
    );
  }
}

class TrackListView extends StatefulWidget {
  const TrackListView({Key? key}) : super(key: key);

  @override
  State<TrackListView> createState() => _TrackListViewState();
}

class _TrackListViewState extends State<TrackListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'Recommended for today'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
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
                      var trackPlayVM = Provider.of<TrackPlayViewModel>(context,
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
                          .indexWhere((track) => track.id == tracks[index].id);
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
          },
        )
      ],
    );
  }
}

class ArtistList extends StatelessWidget {
  const ArtistList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SelectionTitle(title: 'Suggested artists'),
        Consumer<HomeViewModel>(
          builder: (context, value, _) {
            List<Artist>? artists = value.chartArtists.data?.cast<Artist>();
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
                                screen: ArtistDetail(artist: artists![index]),
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
          },
        )
      ],
    );
  }
}
