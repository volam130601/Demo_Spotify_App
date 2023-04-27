import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/network/firebase/favorite_song_service.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';
import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../models/track.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../view_models/download_view_modal.dart';
import '../../models/album.dart';
import '../../models/playlist.dart';
import '../../repository/local/download_repository.dart';
import '../../utils/colors.dart';
import '../../views/home/detail/album_detail.dart';
import '../../views/home/detail/artist_detail.dart';
import '../../views/layout_screen.dart';

class ActionMore extends StatefulWidget {
  const ActionMore(
      {Key? key,
      required this.track,
      this.playlist,
      this.isDownloaded = false,
      this.album,
      this.isAddedFavorite})
      : super(key: key);
  final Track track;
  final Playlist? playlist;
  final Album? album;
  final bool? isDownloaded;
  final bool? isAddedFavorite;

  @override
  State<ActionMore> createState() => _ActionMoreState();
}

class _ActionMoreState extends State<ActionMore> {
  int _value = 0;
  bool _isChecked = false;

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
          Navigator.pop(context);
          DownloadRepository.instance.deleteTrackDownload(track.id!);
          Provider.of<DownloadViewModel>(context, listen: false)
              .removeTrackDownload(track.id!.toInt());
          TrackDownload trackDownload = await DownloadRepository.instance
              .getTrackById(track.id!.toString());
          await FlutterDownloader.remove(
              taskId: trackDownload.taskId.toString(),
              shouldDeleteContent: true);
          ToastCommon.showCustomText(content: 'Deleted from memory');
        },
      );
    } else {
      downloadTileItem = buildModalTileItem(
        context,
        title: 'Download this song',
        icon: const Icon(Icons.download_outlined),
        onTap: () async {
          Navigator.pop(context);
          int totalSize =
              await CommonUtils.getFileSize(track.preview.toString());
          // ignore: use_build_context_synchronously
          buildShowModalDownloadThisSong(context, track, totalSize);
        },
      );
    }
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          buildShowModalMore(
              context, track, downloadTileItem, widget.isAddedFavorite!);
        },
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: Colors.transparent),
        child: const Icon(Icons.more_vert),
      ),
    );
  }

  Future<dynamic> buildShowModalMore(BuildContext context, Track track,
      Widget downloadTileItem, bool isAddedFavorite) {
    return showModalBottomSheet(
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
                isAddedFavorite
                    ? buildModalTileItem(
                        context,
                        title: 'Added to the library',
                        icon: Icon(
                          Icons.favorite,
                          color: ColorsConsts.primaryColorDark,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          ToastCommon.showCustomText(
                              content:
                                  'Removed ${track.title} from the library');
                          FavoriteSongService.instance.deleteItemByTrackId(
                              track.id.toString(),
                              FirebaseAuth.instance.currentUser!.uid);
                        },
                      )
                    : buildModalTileItem(
                        context,
                        title: 'Add to the library',
                        icon: const Icon(Icons.favorite_border_sharp),
                        onTap: () {
                          Navigator.pop(context);
                          ToastCommon.showCustomText(
                              content: 'Added ${track.title} to the library');
                          FavoriteSongService.instance.addItem(
                            FavoriteSong(
                              id: DateTime.now().toString(),
                              trackId: track.id.toString(),
                              albumId: track.album!.id.toString(),
                              artistId: track.artist!.id.toString(),
                              title: track.title,
                              artistName: track.artist!.name,
                              pictureMedium: track.artist!.pictureMedium,
                              coverMedium: track.album!.coverMedium,
                              coverXl: track.album!.coverXl,
                              preview: track.preview,
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              type: 'track',
                            ),
                          );
                        },
                      ),
                buildModalTileItem(
                  context,
                  title: 'Add to playlist',
                  icon: Image.asset(
                    'assets/icons/icons8-add-song-48.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                ),
                buildModalTileItem(
                  context,
                  title: 'View Album',
                  icon: Image.asset(
                    'assets/icons/icons8-disk-24.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(true);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return LayoutScreen(
                            index: 4,
                            screen: AlbumDetail(albumId: track.album!.id!),
                          );
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                buildModalTileItem(
                  context,
                  title: 'View Artist',
                  icon: Image.asset(
                    'assets/icons/icons8-artist-25.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(true);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return LayoutScreen(
                            index: 4,
                            screen: ArtistDetail(artistId: track.artist!.id!),
                          );
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                paddingHeight(1),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> buildShowModalDownloadThisSong(
      BuildContext context, Track track, int totalSize) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(defaultBorderRadius),
              ),
            ),
            child: Column(
              children: [
                paddingHeight(0.5),
                buildHeaderModal(track, context),
                const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Divider(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn chất lượng tải',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      paddingHeight(1),
                      buildChooseDownloadQuality(setState, context,
                          tagName: 'SQ',
                          title: 'Chất lượng tiêu chuẩn',
                          subTitle: 'Tiết kiệm dung lượng bộ nhớ',
                          index: 0),
                      buildChooseDownloadQuality(setState, context,
                          tagName: 'HQ',
                          title: 'Chất lượng cao',
                          subTitle: 'Tốt nhất cho tai nghe và loa',
                          index: 1),
                      const Divider(),
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            checkColor: Colors.black,
                            activeColor: ColorsConsts.primaryColorDark,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Text(
                            'Lưu lựa chọn chất lượng và không hỏi lại',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            final status = await Permission.storage.request();
                            if (status.isGranted) {
                              final externalDir =
                                  await getExternalStorageDirectory();
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
                                await DownloadRepository.instance
                                    .insertTrackDownload(
                                        track: track,
                                        playlistId: widget.playlist!.id);
                              } else if (widget.album != null) {
                                await DownloadRepository.instance
                                    .insertAlbumDownload(widget.album!);
                                await DownloadRepository.instance
                                    .insertTrackDownload(
                                        track: track, album: widget.album);
                              }
                              ToastCommon.showCustomText(
                                  content: 'Add track to downloaded list.');
                            } else {
                              log("Permission denied");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: Text(
                            'TẢI XUỐNG (${CommonUtils.formatSize(totalSize)})',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  InkWell buildChooseDownloadQuality(StateSetter setState, BuildContext context,
      {required String tagName,
      required String title,
      required String subTitle,
      required int index}) {
    return InkWell(
      onTap: () {
        setState(() {
          _value = index;
        });
      },
      child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: Container(
            width: 40,
            height: 35,
            padding: const EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
                  border: Border.all(width: 1, color: Colors.white)),
              child: Center(
                child: Text(
                  tagName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(),
                ),
              ),
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            subTitle,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          trailing: (_value == index)
              ? Icon(
                  Icons.radio_button_checked,
                  color: ColorsConsts.primaryColorDark,
                )
              : const Icon(Icons.radio_button_off)),
    );
  }
}
