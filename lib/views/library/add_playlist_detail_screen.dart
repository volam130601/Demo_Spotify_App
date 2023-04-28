import 'package:demo_spotify_app/data/response/status.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/view_models/library/library_view_model.dart';
import 'package:demo_spotify_app/widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../data/network/firebase/playlist_new_service.dart';
import '../../models/firebase/playlist_new.dart';
import '../../models/track.dart';

class AddPlaylistDetailScreen extends StatefulWidget {
  const AddPlaylistDetailScreen({Key? key, required this.playlistNew})
      : super(key: key);
  final PlaylistNew playlistNew;

  @override
  State<AddPlaylistDetailScreen> createState() =>
      _AddPlaylistDetailScreenState();
}

class _AddPlaylistDetailScreenState extends State<AddPlaylistDetailScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LibraryViewModel>(context, listen: false)
        .fetchTrackSuggestApi(widget.playlistNew.title!, 0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeaderContent(context),
            paddingHeight(1),
            buildAction(context),
            paddingHeight(2),
            //TODO: Fix bug render tracks with Stream builder
            /*StreamBuilder(
              stream: PlaylistNewService.instance
                  .getPlaylistNewByPlaylistIdAndUserId(
                      widget.playlistNew.id.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2),
                    child: Text(
                      'Your playlist is currently empty. Please add some songs to it.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                PlaylistNew? playlistNew = snapshot.data;
                print(playlistNew.toString());
                if (playlistNew != null) {
                  return Scaffold(
                    body: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                } else {
                  List<Track>? tracks = playlistNew!.tracks;
                  if (tracks!.isNotEmpty) {
                    return SizedBox(
                      height: tracks.length * (50 + 16),
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            TrackTileItem(track: tracks[index]),
                        itemCount: tracks.length,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2),
                      child: Text(
                        'Your playlist is currently empty. Please add some songs to it.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                }
              },
            ),*/
            paddingHeight(2),
            Container(
              margin: const EdgeInsets.only(
                  left: defaultPadding, bottom: defaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Track suggest',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Generating suggestions that match your Playlist title.',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ],
              ),
            ),
            /*Consumer<LibraryViewModel>(
              builder: (context, value, child) {
                switch (value.trackSuggests.status) {
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
                    List<Track>? tracks = value.trackSuggests.data;
                    return SizedBox(
                      height: tracks!.length * (50 + 16),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tracks.length,
                        itemBuilder: (context, index) => TrackSuggestTileItem(
                          track: tracks[index],
                          playlistNew: widget.playlistNew,
                        ),
                      ),
                    );
                  case Status.ERROR:
                    return Text(value.trackSuggests.toString());
                  default:
                    return const Text('Default Switch');
                }
              },
            ),*/
            paddingHeight(8),
          ],
        ),
      ),
    );
  }

  Widget buildAction(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding * 3, vertical: defaultPadding),
          side: const BorderSide(width: 1, color: Colors.grey),
        ),
        child: Text(
          'ADD TRACK',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildHeaderContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            height: MediaQuery.of(context).size.width * .5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(defaultBorderRadius / 1.5),
              child: Image.asset(
                'assets/images/music_default.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          paddingHeight(1),
          Text(
            '${widget.playlistNew.title}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          paddingHeight(0.2),
          Text(
            '${widget.playlistNew.userName}',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          paddingHeight(0.2),
          Text(
            '0 track • 3 minutes',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
