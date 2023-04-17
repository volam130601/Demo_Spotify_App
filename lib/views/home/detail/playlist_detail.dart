import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../models/playlist.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../../../view_models/track_play_view_model.dart';
import '../components/play_control/play_button.dart';

class PlaylistDetail extends StatefulWidget {
  const PlaylistDetail({Key? key, required this.playlist, this.userName})
      : super(key: key);
  final Playlist? playlist;
  final String? userName;

  @override
  State<PlaylistDetail> createState() => _PlaylistDetailState();
}

class _PlaylistDetailState extends State<PlaylistDetail> {
  final ScrollController _scrollController = ScrollController();
  late bool isCheckScrollExtendAfter = false;
  late bool isShow = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<TrackPlayViewModel>(context, listen: false)
      ..fetchTracksByPlaylistID(widget.playlist!.id as int, 0, 20)
      ..fetchTracksPlayControl(
          playlistID: widget.playlist!.id as int, index: 0, limit: 20);

    setIsLoading();
    _scrollController.addListener(_onScrollEvent);
  }

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEvent);
    super.dispose();
  }

  void _onScrollEvent() {
    final extentBefore = _scrollController.position.extentBefore;
    if (extentBefore >= 347.4051339285647) {
      setIsShow(true);
    } else {
      setIsShow(false);
    }

    final extentAfter = _scrollController.position.extentAfter;
    if (extentAfter == 0.0) {
      setState(() {
        isCheckScrollExtendAfter = true;
      });
    }
  }

  void setIsShow(newValue) {
    setState(() {
      isShow = newValue;
    });
  }

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
            buildPlaylistBody(context),
            if (isShow) ...{
              Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Container(
                      color: ColorsConsts.scaffoldColorDark,
                      child: playlistActions())),
            }
          ],
        ),
      );
    }
  }

  Widget buildPlaylistBody(BuildContext context) {
    return Consumer<TrackPlayViewModel>(builder: (context, value, _) {
      switch (value.tracksPlayControl.status) {
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
          List<Track>? tracks = value.tracksPlayControl.data;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              buildAppBar(value, context),
              buildHeaderBody(context),
              SliverToBoxAdapter(
                child: playlistActions(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      child: playlistTile(context, tracks[index]),
                      onTap: () {
                        var value = Provider.of<MultiPlayerViewModel>(context,
                            listen: false);
                        int? currentPlaylistId = widget.playlist!.id as int;
                        if (currentPlaylistId != value.getPlaylistId) {
                          value.initState(
                              tracks: tracks,
                              playlistId: widget.playlist!.id as int,
                              index: index);
                        } else {
                          value.player.seek(Duration.zero, index: index);
                        }
                      },
                    );
                  },
                  childCount: tracks!.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Center(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder()),
                        child: Text(
                          'See all tracks',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 5),
                  ],
                ),
              ),
            ],
          );
        case Status.ERROR:
          return Text(value.tracksPlayControl.toString());
        default:
          return const Text('Default Switch');
      }
    });
  }

  SliverToBoxAdapter buildHeaderBody(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 2, vertical: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.playlist!.title as String,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/spotify_logo.svg',
                  fit: BoxFit.cover,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: defaultPadding / 2),
                Text(
                  (widget.userName != null)
                      ? '${widget.userName}'
                      : '${widget.playlist!.user!.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: Colors.white),
                )
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            Text('33.856 likes - 2h 52min',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildAppBar(TrackPlayViewModel provider, BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          provider.tracks.data = [];
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      pinned: true,
      backgroundColor: ColorsConsts.scaffoldColorDark,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image:
              CachedNetworkImageProvider(widget.playlist!.pictureXl as String),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row playlistActions() {
    return Row(
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.favorite_border_sharp)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.downloading)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.shuffle)),
        PlayButton(
          tracks: Provider.of<TrackPlayViewModel>(context, listen: false)
              .tracksPlayControl
              .data!,
          playlistId: widget.playlist!.id,
        ),
        const SizedBox(width: defaultPadding)
      ],
    );
  }

  Padding playlistInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 150,
              height: 150,
              margin: const EdgeInsets.only(top: 40),
              child: CachedNetworkImage(
                imageUrl: widget.playlist!.pictureMedium as String,
                placeholder: (context, url) => Image.asset(
                  'assets/images/music_default.jpg',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            widget.playlist!.title as String,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: defaultPadding / 2),
          Row(
            children: [
              SvgPicture.network(
                'https://upload.wikimedia.org/wikipedia/commons/8/84/Spotify_icon.svg',
                fit: BoxFit.cover,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: defaultPadding / 2),
              Text(
                (widget.userName != null)
                    ? widget.userName as String
                    : widget.playlist!.user!.name as String,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: defaultPadding / 2),
          Text('33.856 likes - 2h 52min',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget playlistTile(BuildContext context, Track? track) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: ListTile(
        leading: CachedNetworkImage(
          width: 50,
          height: 50,
          imageUrl: track!.album!.coverSmall as String,
          fit: BoxFit.cover,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              track.title as String,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  color: Colors.grey,
                  child: const Text(
                    'LYRICS',
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(width: defaultPadding / 2),
                Text(
                  track.artist!.name as String,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            showCustomDialog(context);
          },
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.939),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      final width = MediaQuery.of(context).size.width * .5;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              paddingHeight(5),
              SizedBox(
                width: width,
                height: width,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://e-cdns-images.dzcdn.net/images/cover/ec3c8ed67427064c70f67e5815b74cef/250x250-000000-80-0-0.jpg',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/music_default.jpg',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              paddingHeight(1),
              SizedBox(
                width: width,
                child: Column(
                  children: [
                    Text(
                      'FLOWER',
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'JISOO',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              buildModalTileItem(context,
                  title: 'Listen to music ad-free',
                  icon: const Icon(Icons.diamond_outlined)),
              buildModalTileItem(context,
                  title: 'Like', icon: const Icon(Icons.favorite_border_sharp)),
              buildModalTileItem(context,
                  title: 'Download this song',
                  icon: const Icon(Icons.download_outlined)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              buildModalTileItem(context,
                  title: 'Add to playlist',
                  icon: Image.asset(
                    'assets/icons/icons8-add-song-48.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  )),
              buildModalTileItem(context,
                  title: 'View Album',
                  icon: Image.asset(
                    'assets/icons/icons8-disk-24.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  )),
              buildModalTileItem(context,
                  title: 'View Artist',
                  icon: Image.asset(
                    'assets/icons/icons8-artist-25.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  )),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      }
      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

Widget buildModalTileItem(BuildContext context,
    {String title = '', Widget? icon, VoidCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(width: 60, child: icon),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    ),
  );
}
