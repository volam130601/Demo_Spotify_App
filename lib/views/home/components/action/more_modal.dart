import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/local_model/track_download.dart';
import 'package:demo_spotify_app/view_models/downloader/download_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
  final ReceivePort _port = ReceivePort();
  late DownloadTaskStatus statusDownload = DownloadTaskStatus.undefined;

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader');
    _port.listen((dynamic data) {
      final taskId = (data as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus(data[1] as int);
      final progress = data[2] as int;
      if (status == DownloadTaskStatus.complete) {
        setState(() {
          statusDownload = status;
        });
      }
    });
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    IsolateNameServer.lookupPortByName('downloader')
        ?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    Track? track = widget.track;
    return IconButton(
      onPressed: () {
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
                    SizedBox(
                      height: 60,
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius),
                          child: CachedNetworkImage(
                            imageUrl: '${track!.album!.coverSmall}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/music_default.jpg',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                          '${track.title}',
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${track.artist!.name}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: defaultPadding,
                          right: defaultPadding,
                          top: defaultPadding),
                      child: Divider(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    buildModalTileItem(
                      context,
                      title: 'Download this song',
                      icon: const Icon(Icons.download_outlined),
                      onTap: () async {
                        final status = await Permission.storage.request();
                        if (status.isGranted) {
                          final externalDir =
                              await getExternalStorageDirectory();
                          final taskId = await FlutterDownloader.enqueue(
                            url: '${track.preview}',
                            savedDir: externalDir!.path,
                            showNotification: true,
                            openFileFromNotification: true,
                          );
                          if (taskId != null) {
                            await DownloadProvider.instance.newTrackDownload(
                              TrackDownload(
                                  taskId: taskId,
                                  title: track.title,
                                  artistName: track.artist!.name,
                                  artistPictureSmall:
                                      track.artist!.pictureSmall,
                                  coverSmall: track.album!.coverSmall,
                                  coverXl: track.album!.coverXl,
                                  preview: '${externalDir.path}/$taskId.mp3'),
                            );
                          }
                        } else {
                          log("Permission deined");
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
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.more_vert),
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
