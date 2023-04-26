import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../models/track.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../../../view_models/downloader/download_view_modal.dart';
import '../../models/album.dart';
import '../../models/playlist.dart';
import '../../repository/local/download_repository.dart';

// TODO: Make icon render when download track
class ActionMore extends StatefulWidget {
  const ActionMore(
      {Key? key,
      required this.track,
      this.playlist,
      this.isDownloaded = false,
      this.album})
      : super(key: key);
  final Track track;
  final Playlist? playlist;
  final Album? album;
  final bool? isDownloaded;

  @override
  State<ActionMore> createState() => _ActionMoreState();
}

class _ActionMoreState extends State<ActionMore> {
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    Track? track = widget.track;
    Widget downloadTileItem;
    if (widget.isDownloaded == true) {
      downloadTileItem = buildModalTileItem(
        context,
        title: 'Delete downloaded track',
        icon: const Icon(Ionicons.trash_outline),
        onTap: () async {
          DownloadRepository.instance.deleteTrackDownload(track.id!);
          Provider.of<DownloadViewModel>(context, listen: false)
              .removeTrackDownload(track.id!.toInt());
          TrackDownload trackDownload = await DownloadRepository.instance
              .getTrackById(track.id!.toString());
          await FlutterDownloader.remove(
              taskId: trackDownload.taskId.toString(),
              shouldDeleteContent: true);
          ToastCommon.showCustomText(content: 'Deleted from memory');
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
      );
    } else {
      //TODO: Add modal bottom sheet for download this song.
      downloadTileItem = buildModalTileItem(
        context,
        title: 'Download this song',
        icon: const Icon(Icons.download_outlined),
        onTap: () async {
          final status = await Permission.storage.request();
          if (status.isGranted) {
            final externalDir = await getExternalStorageDirectory();
            await FlutterDownloader.enqueue(
              url: '${track.preview}',
              savedDir: externalDir!.path,
              fileName: 'track-${track.id}.mp3',
              showNotification: false,
              openFileFromNotification: false,
            );
            if (widget.playlist != null) {
              await DownloadRepository.instance
                  .insertPlaylistDownload(widget.playlist!);
              await DownloadRepository.instance.insertTrackDownload(
                  track: track, playlistId: widget.playlist!.id);
            } else if (widget.album != null) {
              await DownloadRepository.instance
                  .insertAlbumDownload(widget.album!);
              await DownloadRepository.instance
                  .insertTrackDownload(track: track, album: widget.album);
            }
            ToastCommon.showCustomText(
                content: 'Add track to downloaded list.');
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          } else {
            log("Permission denied");
          }
        },
      );
    }
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
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
                      buildHeaderModal(track, context),
                      buildDivider(),
                      downloadTileItem,
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
                          List<DownloadTask>? newTasks =
                              await FlutterDownloader.loadTasks();
                          for (int i = 0; i < newTasks!.length; i++) {
                            log('${newTasks[i].filename} : ${newTasks[i].status} : ${newTasks[i].savedDir}');
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
            imageUrl: (widget.album != null)
                ? '${widget.album!.coverMedium}'
                : '${track!.album!.coverSmall}',
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              'assets/images/music_default.jpg',
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          '${track!.title}',
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
