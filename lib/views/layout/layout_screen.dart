import 'dart:isolate';
import 'dart:ui';

import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/views/layout/play_track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import '../../repository/local/download_repository.dart';
import '../../utils/common_utils.dart';
import '../../view_models/download_view_modal.dart';
import 'bottom_bar/bottom_bar_custom.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key, required this.index, required this.screen})
      : super(key: key);
  final int index;
  final Widget screen;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final ReceivePort port = ReceivePort();

  @override
  void initState() {
    super.initState();
    Provider.of<LayoutScreenViewModel>(context, listen: false)
        .setScreenWidget();

    ///Isolate listen: download track
    IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_track');
    final downloadProvider =
        Provider.of<DownloadViewModel>(context, listen: false);
    port.listen((data) async {
      final taskId = data[0];
      final status = data[1];
      if (status == DownloadTaskStatus.complete.value) {
        final tasks = await FlutterDownloader.loadTasks();
        for (var task in tasks!) {
          if (task.taskId == taskId &&
              task.status == DownloadTaskStatus.complete) {
            String trackId =
                CommonUtils.subStringTrackId(task.filename.toString());
            await DownloadRepository.instance.updateTrackDownload(
              trackId: int.parse(trackId),
              taskId: taskId,
              task: task,
            );
            final TrackDownload trackDownload =
                await DownloadRepository.instance.getTrackById(trackId);
            await downloadProvider.addTrackDownload(trackDownload);
          } else if (task.status == DownloadTaskStatus.failed) {
            FlutterDownloader.remove(taskId: task.taskId);
          }
        }
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
    super.dispose();
    IsolateNameServer.removePortNameMapping('downloader_track');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutScreenViewModel>(
      builder: (context, value, child) {
        Widget screen;
        if (widget.index > 3) {
          screen = widget.screen;
        } else {
          screen = value.screen;
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              screen,
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: const [
                    PLayTrackCard(),
                    BottomNavigatorBarCustom(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
