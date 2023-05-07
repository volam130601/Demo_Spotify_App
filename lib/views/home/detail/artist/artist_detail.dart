import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/views/home/detail/artist/track_popular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/network/firebase/follow_artist_service.dart';
import '../../../../data/response/status.dart';
import '../../../../models/artist.dart';
import '../../../../models/firebase/follow_artist.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../../../utils/toast_utils.dart';
import '../../../../view_models/home/artist_view_model.dart';
import '../../../../widgets/play_control/play_button.dart';
import 'album_popular_release.dart';
import 'fan_also_like.dart';
import 'featuring_playlist_of_artist.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistViewModel>(
      builder: (context, value, _) {
        if (value.artist.status == Status.LOADING ||
            value.trackList.status == Status.LOADING ||
            value.albumList.status == Status.LOADING ||
            value.playlistList.status == Status.LOADING ||
            value.artistList.status == Status.LOADING) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }
        if (value.artist.status == Status.COMPLETED) {
          Artist? artist = value.artist.data;
          return Scaffold(
            body: Stack(
              children: [
                buildCustomScrollView(context, artist!),
                if (isShow) ...{
                  Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Container(
                          color: ColorsConsts.scaffoldColorDark,
                          child: actionWidget(context, artist))),
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
        TrackPopular(artist: artist),
        const AlbumPopularRelease(),
        FeaturingPlaylistOfArtist(artist: artist),
        const FanAlsoLike(),
        SliverToBoxAdapter(child: paddingHeight(8))
      ],
    );
  }

  Widget actionWidget(BuildContext context, Artist artist) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          StreamBuilder(
            stream: FollowArtistService.instance.getFollowArtistByUserId(
                FirebaseAuth.instance.currentUser!.uid),
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
              print('load following');
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
