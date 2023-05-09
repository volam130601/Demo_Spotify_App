import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../config/permission_handler.dart';
import '../../models/album.dart';
import '../../models/local/track_download.dart';
import '../../models/playlist.dart';
import '../../models/track.dart';
import '../../repository/local/download_repository.dart';
import '../../utils/colors.dart';
import '../../utils/common_utils.dart';
import '../../utils/constants/default_constant.dart';
import '../../utils/toast_utils.dart';
import '../../view_models/download_view_modal.dart';

class ModalDownloadTrack extends StatefulWidget {
  const ModalDownloadTrack(
      {Key? key,
      required this.context,
      required this.track,
      required this.album,
      this.playlist,
      this.isIconButton = false})
      : super(key: key);
  final BuildContext context;
  final Track track;
  final Album? album;
  final Playlist? playlist;
  final bool? isIconButton;

  @override
  State<ModalDownloadTrack> createState() => _ModalDownloadTrackState();
}

class _ModalDownloadTrackState extends State<ModalDownloadTrack> {
  int _value = 0;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    Track track = widget.track;
    if (widget.isIconButton == true) {
      return Selector<DownloadViewModel, bool>(
        selector: (context, viewModel) {
          final bool isDownloaded =
              viewModel.trackDownloads.any((item) => item.id == track.id!);
          return isDownloaded;
        },
        builder: (context, isDownloaded, child) {
          if (isDownloaded == true) {
            return IconButton(
                onPressed: () async {
                  DownloadRepository.instance.deleteTrackDownload(track.id!);
                  Provider.of<DownloadViewModel>(context, listen: false)
                      .removeTrackDownload(track.id!.toInt());
                  TrackDownload trackDownload = await DownloadRepository
                      .instance
                      .getTrackById(track.id!.toString());
                  await FlutterDownloader.remove(
                      taskId: trackDownload.taskId.toString(),
                      shouldDeleteContent: true);
                  ToastCommon.showCustomText(content: 'Deleted from memory');
                },
                style: IconButton.styleFrom(
                    elevation: 0, padding: const EdgeInsets.all(0)),
                icon: Icon(Ionicons.arrow_down_circle_outline,
                    color: ColorsConsts.primaryColorDark));
          } else {
            return IconButton(
                onPressed: () {
                  if (widget.album != null) {
                    buildShowModalDownloadThisSong(
                        context, track, widget.album!);
                  } else {
                    buildShowModalDownloadThisSong(
                        context, track, track.album!);
                  }
                },
                style: IconButton.styleFrom(
                    elevation: 0, padding: const EdgeInsets.all(0)),
                icon: Icon(Ionicons.arrow_down_circle_outline,
                    color: Colors.grey.shade300));
          }
        },
      );
    } else {
      return Selector<DownloadViewModel, bool>(
        selector: (context, viewModel) {
          final bool isDownloaded =
              viewModel.trackDownloads.any((item) => item.id == track.id!);
          return isDownloaded;
        },
        builder: (context, isDownloaded, child) {
          if (isDownloaded == true) {
            return buildModalTileItem(
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
            return buildModalTileItem(
              context,
              title: 'Download this song',
              icon: const Icon(Icons.download_outlined),
              onTap: () {
                Navigator.pop(context);
                if (widget.album != null) {
                  buildShowModalDownloadThisSong(context, track, widget.album!);
                } else {
                  buildShowModalDownloadThisSong(context, track, track.album!);
                }
              },
            );
          }
        },
      );
    }
  }

  Future<dynamic> buildShowModalDownloadThisSong(
      BuildContext context, Track track, Album album) {
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
                buildHeaderModal(track, context, album),
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
                            bool isGranted = await PermissionHandler
                                    .requestMediasPermissions()
                                .then((value) => value);
                            if (isGranted) {
                              final externalDir =
                                  await getExternalStorageDirectory();
                              if (widget.playlist != null) {
                                await DownloadRepository.instance
                                    .insertPlaylistDownload(widget.playlist!);
                                await DownloadRepository.instance
                                    .insertTrackDownload(
                                        track: track,
                                        playlistId: widget.playlist!.id);
                              } else if (widget.album != null) {
                                await DownloadRepository.instance
                                    .insertAlbumDownload(widget.album!,
                                        track: track);
                                await DownloadRepository.instance
                                    .insertTrackDownload(
                                        track: track, album: widget.album);
                              }
                              await FlutterDownloader.enqueue(
                                url: '${track.preview}',
                                savedDir: externalDir!.path,
                                fileName: 'track-${track.id}.mp3',
                                showNotification: false,
                                openFileFromNotification: false,
                              );
                              ToastCommon.showCustomText(
                                  content: 'Add track to downloaded list.');
                            } else {
                              ToastCommon.showCustomText(content: "Permission denied");
;                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: FutureBuilder(
                            future: CommonUtils.getFileSize(
                                track.preview.toString()),
                            builder: (context, snapshot) => Text(
                              'TẢI XUỐNG (${snapshot.data != null ? CommonUtils.formatSize(snapshot.data!) : '0.0MB'})',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            ),
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

  SizedBox buildHeaderModal(Track track, BuildContext context, Album album) {
    return SizedBox(
      height: 60,
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            child: CachedNetworkImage(
              imageUrl: '${album.coverMedium}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.asset(
                'assets/images/music_default.jpg',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
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
