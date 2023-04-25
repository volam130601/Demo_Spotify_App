import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:demo_spotify_app/models/track.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/widgets/container_null_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../repository/local/download_repository.dart';

class TabTrack extends StatefulWidget {
  const TabTrack({Key? key}) : super(key: key);

  @override
  State<TabTrack> createState() => _TabTrackState();
}

class _TabTrackState extends State<TabTrack> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrackDownload>>(
      future: DownloadRepository.instance.getAllTrackDownloads(),
      builder:
          (BuildContext context, AsyncSnapshot<List<TrackDownload>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const ContainerNullValue(
              image: 'assets/images/library/album_none.png',
              title: 'You haven\'t downloaded any track yet.',
              subtitle:
                  'Download your favorite track so you can play it when there is no internet connection.',
            );
          }
          List<Track> tracks = CommonUtils.convertTrackDownloadsToTracks(snapshot.data!);
          return ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == snapshot.data!.length) {
                return paddingHeight(8);
              }
              TrackDownload? trackDownload = snapshot.data![index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  DownloadRepository.instance
                      .deleteTrackDownload(trackDownload.id!);
                  FlutterDownloader.remove(
                      taskId: trackDownload.taskId!, shouldDeleteContent: true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/spotify_logo.svg',
                            width: 20,
                            height: 20,
                          ),
                          paddingWidth(0.5),
                          const Text('Deleted from memory'),
                        ],
                      ),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                child: InkWell(
                  onTap: () async {
                    var value = Provider.of<MultiPlayerViewModel>(context,
                        listen: false);
                    value.initState(tracks: tracks, index: index);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    height: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            child: CachedNetworkImage(
                              imageUrl: '${trackDownload.coverSmall}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                'assets/images/music_default.jpg',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        paddingWidth(1),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                trackDownload.title.toString(),
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                trackDownload.artistName.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: ElevatedButton(
                            onPressed: () async {
                              List<DownloadTask>? tasks =
                                  await FlutterDownloader.loadTasks();
                              for (var item in tasks!) {
                                log('$item');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                            ),
                            child: const Center(
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
