import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/views/home/play_control/play_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/default_constant.dart';

class TrackPlay extends StatefulWidget {
  const TrackPlay({Key? key}) : super(key: key);

  @override
  State<TrackPlay> createState() => _TrackPlayState();
}

class _TrackPlayState extends State<TrackPlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MultiPlayerViewModel>(builder: (context, value, child) {
        return Stack(
          children: [
            buildImageBackground(context, value),
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black45,
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: buildPlayControlBox(),
            ),
            Positioned(
                left: 0, right: 0, top: 20, child: buildHeader(context, value)),
          ],
        );
      }),
    );
    /* return Scaffold(
      body: Consumer<TrackPlayViewModel>(
        builder: (context, value, _) {
          switch (value.tracksPlayControl.status) {
            case Status.LOADING:
              return Container(
                height: double.infinity,
                color: Colors.black54,
              );
            case Status.COMPLETED:
              return Consumer<MultiPlayerViewModel>(
                  builder: (context, value, child) {
                return Stack(
                  children: [
                    buildImageBackground(context, value),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.black45,
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: buildPlayControlBox(),
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 20,
                        child: buildHeader(context, value)),
                  ],
                );
              });
            case Status.ERROR:
              return Text(value.tracksPlayControl.toString());
            default:
              return const Text('Default Switch');
          }
        },
      ),
    );*/
  }

  SizedBox buildPlayControlBox() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 200, width: 400, child: PlayControl())
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, MultiPlayerViewModel value) {
    return StreamBuilder<SequenceState?>(
      stream: value.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;

        String? image;
        if (metadata.artist != null) {
          var value = metadata.artHeaders!['artArtist'];
          image = value.toString();
        } else {
          image = value.getAlbum.artist!.pictureSmall as String;
        }
        return Column(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                IconlyLight.arrowDown2,
                size: 40,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius / 2)),
                    child: CachedNetworkImage(
                      imageUrl: image,
                      placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: defaultPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metadata.title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          metadata.artist as String,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontSize: 18),
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
                        )),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildImageBackground(
      BuildContext context, MultiPlayerViewModel value) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.height;

    return StreamBuilder<SequenceState?>(
      stream: value.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height,
              width: width,
              child: CachedNetworkImage(
                imageUrl: metadata.artUri.toString(),
                placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            )
          ],
        );
      },
    );
  }
}
