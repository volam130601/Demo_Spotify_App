import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/response/status.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:demo_spotify_app/views/home/components/selection_title.dart';
import 'package:demo_spotify_app/views/home/detail/album_detail.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/album.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants/default_constant.dart';
import '../components/card_item_custom.dart';

class TrackDetail extends StatefulWidget {
  const TrackDetail({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<TrackDetail> createState() => _TrackDetailState();
}

class _TrackDetailState extends State<TrackDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TrackPlayViewModel>(context, listen: false)
        .fetchTracksByID(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Consumer<TrackPlayViewModel>(
                builder: (context, value, _) {
                  switch (value.trackDetail.status) {
                    case Status.LOADING:
                      return SizedBox(
                        height: height,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case Status.COMPLETED:
                      return _trackDetailView(context, value.trackDetail.data);
                    case Status.ERROR:
                      return Text(value.trackDetail.toString());
                    default:
                      return const Text('Default Switch');
                  }
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            const YouMightAlsoLike(),
          ],
        ),
      ),
    );
  }

  Column _trackDetailView(BuildContext context, Track? track) {
    final year = track!.releaseDate!.split('-').first;
    String releaseDate = DateFormat('MMMM d, y')
        .format(DateTime.parse(track.releaseDate as String));

    int seconds = track.duration as int;
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    String formattedTime = "$minutes min $remainingSeconds sec";

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: CachedNetworkImage(
                imageUrl: track.album!.coverMedium as String,
                placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
        const SizedBox(height: defaultPadding),
        SizedBox(
          child: Text(
            track.title as String,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        const SizedBox(height: defaultPadding / 2),
        Row(
          children: [
            SizedBox(
              width: 24,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                    track.artist!.pictureMedium as String),
              ),
            ),
            const SizedBox(width: 4),
            Text(track.artist!.name as String),
          ],
        ),
        const SizedBox(height: defaultPadding / 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Single - $year',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: defaultPadding / 4),
        Row(
          children: [
            const Icon(Icons.favorite_border_sharp),
            const SizedBox(width: defaultPadding),
            const Icon(Icons.downloading),
            const SizedBox(width: defaultPadding),
            const Icon(Icons.more_vert),
            Expanded(child: Container()),
            const Icon(Icons.shuffle),
            const SizedBox(width: defaultPadding),
            SizedBox(
              width: 50,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                ),
                child: const Icon(Icons.play_arrow),
              ),
            )
          ],
        ),
        const SizedBox(height: defaultPadding / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title as String,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ColorsConsts.primaryColorDark),
                ),
                Text(track.artist!.name as String,
                    style: Theme.of(context).textTheme.titleSmall),
              ], //continue
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
        const SizedBox(height: defaultPadding / 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(releaseDate),
              const SizedBox(height: defaultPadding / 4),
              Text('1 song - $formattedTime'),
              const SizedBox(height: defaultPadding / 2),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                        track.artist!.pictureMedium as String),
                  ),
                  const SizedBox(width: defaultPadding / 4),
                  Text(track.artist!.name as String)
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class YouMightAlsoLike extends StatefulWidget {
  const YouMightAlsoLike({Key? key}) : super(key: key);

  @override
  State<YouMightAlsoLike> createState() => _YouMightAlsoLikeState();
}

class _YouMightAlsoLikeState extends State<YouMightAlsoLike> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HomeViewModel>(context, listen: false).fetchChartAlbumsApi();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SelectionTitle(title: 'You might also like'),
        SizedBox(
          height: 200,
          child: Consumer<HomeViewModel>(
            builder: (context, value, _) {
              switch (value.chartAlbums.status) {
                case Status.LOADING:
                  return SizedBox(
                    height: height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case Status.COMPLETED:
                  return _playlistCardList(height, value);
                case Status.ERROR:
                  return Text(value.chartAlbums.toString());
                default:
                  return const Text('Default Switch');
              }
            },
          ),
        )
      ],
    );
  }

  Widget _playlistCardList(double height, HomeViewModel value) {
    List<Album>? albums = value.chartAlbums.data;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: albums!.length,
      itemBuilder: (BuildContext context, int index) {
        return CardItemCustom(
          image: albums[index].coverXl as String,
          titleTop: albums[index].title,
          titleBottom: albums[index].artist!.name,
          centerTitle: true,
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => LayoutScreen(
                      index: 4,
                      screen: AlbumDetail(album: albums[index]),
                    )));
          },
        );
      },
    );
  }
}
