import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../repository/local/download_repository.dart';
import '../../utils/constants/default_constant.dart';
import '../../view_models/downloader/download_view_modal.dart';
import '../../widgets/container_null_value.dart';
import 'tab_view/tab_playlist.dart';
import 'tab_view/tab_track.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_sharp)),
          IconButton(
              onPressed: () async {
                final downloadProvider =
                    Provider.of<DownloadViewModel>(context, listen: false);
                await DownloadRepository.instance.removeAll();
                await downloadProvider.loadTracksDownloaded();
              },
              icon: const Icon(Ionicons.trash_outline)),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Downloaded',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              'Music has been downloaded or is on the device.',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            paddingHeight(2),
            Container(
              height: 35,
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(defaultBorderRadius * 2),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Track'),
                  Tab(text: 'Playlist'),
                  Tab(text: 'Album'),
                ],
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.white,
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  color: Colors.grey,
                ),
              ),
            ),
            paddingHeight(2),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                children: const [
                  TabTrack(),
                  TabPlaylist(),
                  ContainerNullValue(
                    image: 'assets/images/library/album_none.png',
                    title: 'You haven\'t downloaded any albums yet.',
                    subtitle:
                        'Download your favorite albums so you can play it when there is no internet connection.',
                  ),
                ],
              ),
            ),
            paddingHeight(5),
          ],
        ),
      ),
    );
  }
}
