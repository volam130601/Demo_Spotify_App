import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:demo_spotify_app/views/search/search_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../models/playlist.dart';
import '../../../../models/track.dart';
import '../../../../view_models/downloader/download_view_modal.dart';
import '../../models/album.dart';
import '../../repository/local/download_repository.dart';
import '../../utils/colors.dart';
import '../../utils/constants/default_constant.dart';

class ActionDownloadTracks extends StatefulWidget {
  const ActionDownloadTracks(
      {Key? key, this.playlist, this.album, this.tracks, this.sizeFileDownload})
      : super(key: key);
  final Playlist? playlist;
  final Album? album;
  final List<Track>? tracks;
  final String? sizeFileDownload;

  @override
  State<ActionDownloadTracks> createState() => _ActionDownloadTracksState();
}

class _ActionDownloadTracksState extends State<ActionDownloadTracks> {
  final ReceivePort port = ReceivePort();
  late int _value = 0;
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
    List<Track> trackDownloads =
        widget.tracks!.where((track) => track.preview != '').toList();
    return Row(
      children: [
        IconButton(
          onPressed: () {
            showModalBottomSheet(
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
                        buildHeaderModal(context),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding,
                                    vertical: defaultPadding),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade600,
                                    borderRadius: BorderRadius.circular(
                                        defaultBorderRadius / 2)),
                                width: double.infinity,
                                child: Text(
                                    'Bạn có thể tải ${trackDownloads.length}/${widget.playlist!.nbTracks} bài hát của playlist.'),
                              ),
                              paddingHeight(1),
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
                                    final status =
                                        await Permission.storage.request();
                                    if (status.isGranted) {
                                      if (widget.playlist != null) {
                                        ToastCommon.showCustomText(
                                            content:
                                                'Add playlist to download list');
                                        await DownloadRepository.instance
                                            .downloadTracks(trackDownloads,
                                                playlistId:
                                                    widget.playlist!.id);
                                        await DownloadRepository.instance
                                            .insertPlaylistDownload(
                                                widget.playlist!);
                                      }
                                      if (widget.album != null) {
                                        ToastCommon.showCustomText(
                                            content:
                                                'Add album to download list');
                                        await DownloadRepository.instance
                                            .downloadTracks(trackDownloads,
                                                album: widget.album);
                                        await DownloadRepository.instance
                                            .insertAlbumDownload(widget.album!);
                                      }
                                    } else {
                                      log("Permission denied");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder()),
                                  child: Text(
                                    (widget.sizeFileDownload != null)
                                        ? 'TẢI PLAYLIST (${widget.sizeFileDownload})'
                                        : 'TẢI PLAYLIST (0.0 MB)',
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
          },
          icon: const Icon(Icons.downloading),
        ),
      ],
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

  Widget buildHeaderModal(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
          child: CachedNetworkImage(
            imageUrl: (widget.album != null)
                ? '${widget.album!.coverMedium}'
                : '${widget.playlist!.pictureMedium}',
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
        (widget.album != null)
            ? '${widget.album!.title}'
            : '${widget.playlist!.title}',
        style: Theme.of(context).textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text(
            '${widget.playlist!.creator!.name}',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
