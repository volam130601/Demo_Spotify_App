import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/network/firebase/follow_artist_service.dart';
import '../../../data/response/status.dart';
import '../../../models/album.dart';
import '../../../models/artist.dart';
import '../../../models/firebase/follow_artist.dart';
import '../../../models/playlist.dart';
import '../../../models/track.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../utils/toast_utils.dart';
import '../../../view_models/home/artist_view_model.dart';
import '../../../widgets/play_control/play_button.dart';
import '../../../widgets/selection_title.dart';

class ArtistDetail extends StatefulWidget {
  const ArtistDetail({Key? key, required this.artistId}) : super(key: key);
  final int artistId;

  @override
  State<ArtistDetail> createState() => _ArtistDetailState();
}

class _ArtistDetailState extends State<ArtistDetail> {
  final ScrollController _scrollController = ScrollController();
  late bool isShow = false;
  late bool isShowTitle = false;

  @override
  void initState() {
    Provider.of<ArtistViewModel>(context, listen: false)
      ..fetchArtistApi(widget.artistId)
      ..fetchTrackPopularByArtistID(widget.artistId, 0, 10000)
      ..fetchAlbumPopularByArtistID(widget.artistId, 0, 4)
      ..fetchPlaylistByArtistID(widget.artistId, 0, 5)
      ..fetchArtistRelatedByArtistID(widget.artistId, 0, 5);

    _scrollController.addListener(_onScrollEvent);
    super.initState();
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
    return Consumer<ArtistViewModel>(
      builder: (context, value, _) {
        if(value.artist.status == Status.LOADING ||
            value.trackList.status == Status.LOADING ||
            value.albumList.status == Status.LOADING ||
            value.playlistList.status == Status.LOADING ||
            value.artistList.status == Status.LOADING
        ) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }
        if(value.artist.status == Status.COMPLETED) {
          Artist? artist = value.artist.data;
          return Scaffold(
            body: Stack(
              children: [
                buildCustomScrollView(context, artist!),
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
        return Scaffold(
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  Widget buildCustomScrollView(BuildContext context, Artist artist) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        buildSliverAppBar(context, artist),
        buildHeaderBody(context, artist),
        SliverToBoxAdapter(child: actionWidget(context, artist)),
        trackPopular(context),
        albumPopularReleases(context),
        featuringListViewWidget(context, artist),
        fansAlsoLike(context),
        const SliverToBoxAdapter(
          child: SizedBox(height: defaultPadding * 4),
        )
      ],
    );
  }

  Widget trackPopular(BuildContext context) {
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
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      tracks[index].album!.coverSmall as String,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget albumPopularReleases(BuildContext context) {
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

  Widget featuringListViewWidget(BuildContext context, Artist artist) {
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
                          return Row(
                            children: [
                              const SizedBox(width: defaultPadding),
                              SizedBox(
                                width: 120,
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: playlists[index].pictureMedium
                                          as String,
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

  Widget fansAlsoLike(BuildContext context) {
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
                          return Row(
                            children: [
                              const SizedBox(width: defaultPadding),
                              SizedBox(
                                width: 120,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              artists[index].pictureMedium
                                                  as String),
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

  Widget actionWidget(BuildContext context, Artist artist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          StreamBuilder(
            stream: FollowArtistService.instance
                .getFollowArtistByUserId(CommonUtils.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white)),
                  child: Text(
                    'Following',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
              FollowArtist? followArtist = snapshot.data;
              List<Artist>? artists = followArtist!.artists;
              bool checkFollowing =
                  artists!.any((element) => element.id == widget.artistId);

              return checkFollowing
                  ? ElevatedButton(
                      onPressed: () {
                        Artist temp = artists.firstWhere(
                            (element) => element.id == widget.artistId);
                        followArtist.artists!.remove(temp);
                        FollowArtistService.instance.updateItem(followArtist);
                        ToastCommon.showCustomText(
                          content: 'Remove ${artist.name} from follow artist',
                        );
                      },
                      child: Text('Following',
                          style: Theme.of(context).textTheme.titleLarge))
                  : OutlinedButton(
                      onPressed: () {
                        followArtist.artists!.add(artist);
                        FollowArtistService.instance.updateItem(followArtist);
                        ToastCommon.showCustomText(
                            content: 'Following artist ${artist.name}');
                      },
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white)),
                      child: Text('Following',
                          style: Theme.of(context).textTheme.titleLarge));
            },
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
          Consumer<ArtistViewModel>(
            builder: (context, value, child) {
              switch (value.trackList.status) {
                case Status.LOADING:
                  return const PlayButton(tracks: []);
                case Status.COMPLETED:
                  return PlayButton(
                    tracks: value.trackList.data!,
                    artist: artist,
                    artistId: artist.id,
                  );
                case Status.ERROR:
                  return Text(value.trackList.toString());
                default:
                  return const Text('Default Switch');
              }
            },
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter buildHeaderBody(BuildContext context, Artist artist) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${CommonUtils.convertToShorthand(artist.nbFan!.toInt())} monthly listeners',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar(BuildContext context, Artist artist) {
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
            artist.pictureXl as String,
          ),
          fit: BoxFit.cover,
        ),
        title: Text(
          artist.name as String,
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
