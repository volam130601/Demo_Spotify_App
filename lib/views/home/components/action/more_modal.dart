import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/local_model/track_download.dart';
import 'package:demo_spotify_app/data/local/download_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../models/track.dart';
import '../../../../utils/constants/default_constant.dart';

class ActionMore extends StatefulWidget {
  const ActionMore({Key? key, this.track}) : super(key: key);
  final Track? track;

  @override
  State<ActionMore> createState() => _ActionMoreState();
}

class _ActionMoreState extends State<ActionMore> {
  final ReceivePort port = ReceivePort();
  bool isTrackExists = false;
  late String currentTaskId;

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_track');
    port.listen((data) async {
      final taskId = data[0];
      final status = data[1];
      final progress = data[2];
      if (status == DownloadTaskStatus.complete.value) {
        Track track = widget.track!;
        final externalDir = await getExternalStorageDirectory();
        await DownloadDBService.instance.newTrackDownload(
          TrackDownload(
              trackId: track.id.toString(),
              taskId: taskId,
              title: track.title,
              artistName: track.artist!.name,
              artistPictureSmall: track.artist!.pictureSmall,
              coverSmall: track.album!.coverSmall,
              coverXl: track.album!.coverXl,
              preview: '${externalDir!.path}/$taskId.mp3'),
        );
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    IsolateNameServer.lookupPortByName('downloader_track')
        ?.send([id, status.value, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_track');
    super.dispose();
  }

  Future<void> checkTrackExists() async {
    await FlutterDownloader.loadTasks().then((value) {
      for (var item in value!) {
        if (item.filename == 'track-${widget.track!.id.toString()}') {
          setState(() {
            isTrackExists = true;
            currentTaskId = item.taskId;
            return;
          });
        }
      }
    });
  }

  void setIsTrackExits(newValue) {
    setState(() {
      isTrackExists = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    Track? track = widget.track;
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          checkTrackExists();
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) {
              return Container(
                height: MediaQuery.of(context).size.height * .5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(defaultBorderRadius),
                    topRight: Radius.circular(defaultBorderRadius),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      paddingHeight(0.5),
                      buildHeaderModal(track, context),
                      buildDivider(),
                      isTrackExists
                          ? buildModalTileItem(
                              context,
                              title: 'Delete downloaded track',
                              icon: const Icon(Ionicons.trash_outline),
                              onTap: () async {
                                DownloadDBService.instance
                                    .deleteTrackDownload(track!.id.toString());
                                FlutterDownloader.remove(
                                    taskId: currentTaskId,
                                    shouldDeleteContent: true);
                                setIsTrackExits(false);
                                Navigator.pop(context);
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
                            )
                          : buildModalTileItem(
                              context,
                              title: 'Download this song',
                              icon: const Icon(Icons.download_outlined),
                              onTap: () async {
                                final status =
                                    await Permission.storage.request();
                                if (status.isGranted) {
                                  final externalDir =
                                      await getExternalStorageDirectory();
                                  await FlutterDownloader.enqueue(
                                    url: '${track!.preview}',
                                    savedDir: externalDir!.path,
                                    fileName: 'track-${track.id}',
                                    showNotification: false,
                                    openFileFromNotification: false,
                                  );
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
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
                                          const Text(
                                              'Add track to downloaded list'),
                                        ],
                                      ),
                                      duration:
                                          const Duration(milliseconds: 500),
                                    ),
                                  );
                                } else {
                                  log("Permission denied");
                                }
                              },
                            ),
                      buildModalTileItem(context,
                          title: 'Like',
                          icon: const Icon(Icons.favorite_border_sharp)),
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
                      buildModalTileItem(
                        context,
                        title: 'View Artist',
                        icon: Image.asset(
                          'assets/icons/icons8-artist-25.png',
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                        onTap: () async {
                          List<DownloadTask>? tasks =
                              await FlutterDownloader.loadTasks();
                          for (var item in tasks!) {
                            print(item.taskId);
                            // FlutterDownloader.remove(taskId: item.taskId, shouldDeleteContent: true);
                          }
                        },
                      ),
                      paddingHeight(1),
                    ],
                  ),
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: Colors.transparent),
        child: const Icon(Icons.more_vert),
      ),
    );
  }

  Padding buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: defaultPadding),
      child: Divider(
        color: Colors.grey.shade600,
      ),
    );
  }

  SizedBox buildHeaderModal(Track? track, BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          child: CachedNetworkImage(
            imageUrl: '${track!.album!.coverSmall}',
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              'assets/images/music_default.jpg',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          '${track.title}',
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              '${track.artist!.name}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined),
        ),
      ),
    );
  }

  Widget buildModalTileItem(BuildContext context,
      {String title = '', Widget? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: 60, child: icon),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
