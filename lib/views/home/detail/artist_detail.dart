import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/album.dart';
import '../../../models/artist.dart';
import '../../../models/playlist.dart';
import '../../../models/track.dart';
import '../../../res/colors.dart';
import '../../../res/components/play_control/play_button.dart';
import '../../../res/constants/default_constant.dart';
import '../../../view_models/artist_view_model.dart';
import '../../../view_models/track_play_view_model.dart';

class ArtistDetail extends StatefulWidget {
  const ArtistDetail({Key? key, required this.artist}) : super(key: key);
  final Artist artist;

  @override
  State<ArtistDetail> createState() => _ArtistDetailState();
}

class _ArtistDetailState extends State<ArtistDetail> {
  final ScrollController _scrollController = ScrollController();

  late bool isShow = false;
  late bool isShowTitle = false;
  bool isLoading = true;

  @override
  void initState() {
    final int artistID = widget.artist.id as int;
    Provider.of<ArtistViewModel>(context, listen: false)
      ..fetchArtistApi(artistID)
      ..fetchTrackPopularByArtistID(artistID, 0, 5)
      ..fetchAlbumPopularByArtistID(artistID, 0, 4)
      ..fetchPlaylistByArtistID(artistID, 0, 5)
      ..fetchTrackRadiosByArtistID(artistID, 0, 5)
      ..fetchArtistRelatedByArtistID(artistID, 0, 5);

    Provider.of<TrackPlayViewModel>(context, listen: false)
        .fetchTracksPlayControl(artistID: artistID, index: 0, limit: 20);
    setIsLoading();

    _scrollController.addListener(_onScrollEvent);
    super.initState();
  }

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  void scrollTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onScrollEvent() {
    final extentBefore = _scrollController.position.extentBefore;
    if (extentBefore >= 316) {
      setIsShow(true);
    } else {
      setIsShow(false);
    }

    if (extentBefore >= 210) {
      setIsShowTitle(true);
    } else {
      setIsShowTitle(false);
    }
  }

  void setIsShow(newValue) {
    setState(() {
      isShow = newValue;
    });
  }

  void setIsShowTitle(newValue) {
    setState(() {
      isShowTitle = newValue;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 40,
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: [
            buildCustomScrollView(context),
            if (isShow) ...{
              Positioned(
                top: 60,
                right: 15,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(0),
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.play_arrow)),
                ),
              )
            },
          ],
        ),
      );
    }
  }

  Widget buildCustomScrollView(BuildContext context) {
    return Consumer<ArtistViewModel>(
      builder: (context, value, _) {
        switch (value.artist.status) {
          case Status.LOADING:
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          case Status.COMPLETED:
            List<Track>? tracks = value.trackList.data;
            List<Playlist>? playlists = value.playlistList.data;
            List<Artist>? artists = value.artistList.data;
            List<Album>? albums = value.albumList.data;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                buildSliverAppBar(context),
                buildHeaderBody(context),
                actionWidget(context, tracks!),
                trackPopular(context, tracks),
                albumPopularReleases(context, albums!),
                featuringListViewWidget(context, playlists!),
                fansAlsoLike(context, artists!),
                const SliverToBoxAdapter(
                  child: SizedBox(height: defaultPadding * 4),
                )
              ],
            );
          case Status.ERROR:
            return Text(value.artist.toString());
          default:
            return const Text('Default Switch');
        }
      },
    );
  }

  SliverToBoxAdapter trackPopular(BuildContext context, List<Track> tracks) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectionTitle('Popular'),
          SizedBox(
            height: 60 * tracks.length.toDouble(),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => SizedBox(
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
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  tracks[index].album!.coverSmall as String))),
                    ),
                    const SizedBox(width: defaultPadding / 2),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tracks[index].title as String,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trackFans[index],
                            style: Theme.of(context).textTheme.titleSmall,
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
              itemCount: tracks.length,
            ),
          )
        ],
      ),
    );
  }

  SliverToBoxAdapter albumPopularReleases(
      BuildContext context, List<Album> albums) {
    albums.sort((a, b) => b.fans!.compareTo(a.fans as num));
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectionTitle('Popular releases'),
          SizedBox(
            height: 70 * (albums.length.toDouble() + 1),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final formatter = NumberFormat('#,###');
                String numberFans = formatter.format(albums[index].fans! * 100);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  margin: const EdgeInsets.only(bottom: defaultPadding),
                  height: 70,
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  albums[index].coverSmall as String),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: defaultPadding),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              albums[index].title as String,
                              style: Theme.of(context).textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              numberFans,
                              style: Theme.of(context).textTheme.titleSmall,
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
              style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
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
  }

  SliverToBoxAdapter featuringListViewWidget(
      BuildContext context, List<Playlist> playlists) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectionTitle('Featuring ${widget.artist.name}'),
          SizedBox(
            height: 180.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      width: 120,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter fansAlsoLike(BuildContext context, List<Artist> artists) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectionTitle('Fans also like'),
          SizedBox(
            height: 180.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artists.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const SizedBox(width: defaultPadding),
                    SizedBox(
                      width: 120,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter actionWidget(BuildContext context, List<Track> tracks) {
    return SliverToBoxAdapter(
      child: Row(
        children: [
          const SizedBox(width: defaultPadding),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white)),
            child: Text(
              'Following',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          const Expanded(child: SizedBox()),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
          PlayButton(
            tracks: Provider.of<TrackPlayViewModel>(context, listen: false)
                .tracksPlayControl
                .data!,
            artist: widget.artist,
            artistId: widget.artist.id,
          ),
          const SizedBox(width: defaultPadding)
        ],
      ),
    );
  }

  Widget selectionTitle(var title) {
    return Column(
      children: [
        const SizedBox(height: defaultPadding),
        Padding(
          padding: const EdgeInsets.only(left: defaultPadding),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }

  SliverToBoxAdapter buildHeaderBody(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('668,263 monthly listeners',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isShow ? Colors.transparent : Colors.black12,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              elevation: 0,
              backgroundColor: Colors.transparent),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      pinned: true,
      backgroundColor: isShow ? Colors.grey : ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: CachedNetworkImageProvider(
            widget.artist.pictureXl as String,
          ),
          fit: BoxFit.cover,
        ),
        title: Text(
          widget.artist.name as String,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              shadows: [
                const Shadow(offset: Offset(-0.2, -0.2), color: Colors.black),
                const Shadow(offset: Offset(0.2, -0.2), color: Colors.black),
                const Shadow(offset: Offset(0.2, 0.2), color: Colors.black),
                const Shadow(offset: Offset(-0.2, 0.2), color: Colors.black),
              ]),
        ),
        centerTitle: false,
        expandedTitleScale: 2,
        titlePadding: EdgeInsets.only(
            left: isShowTitle ? defaultPadding * 4 : defaultPadding,
            bottom: defaultPadding * 1.1),
      ),
    );
  }
}
