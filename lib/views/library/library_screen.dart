import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/album.dart';
import 'package:demo_spotify_app/models/artist.dart';
import 'package:demo_spotify_app/models/local_model/track_download.dart';
import 'package:demo_spotify_app/views/home/components/selection_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../data/local/download_database_service.dart';
import '../../models/category/category_library.dart';
import '../../models/track.dart';
import '../../utils/constants/default_constant.dart';
import '../../view_models/multi_control_player_view_model.dart';
import '../home/components/container_null_value.dart';
import '../layout_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _auth = FirebaseAuth.instance;
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (_auth.currentUser != null) {
      setState(() {
        isCheck = true;
      });
    } else {
      setState(() {
        isCheck = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SelectionTitle(title: 'Library'),
                  buildListLibrary(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 180,
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Playlist'),
                      Tab(text: 'Album'),
                    ],
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    padding: const EdgeInsets.only(
                        top: defaultPadding / 2,
                        bottom: defaultPadding / 2,
                        right: defaultPadding),
                    indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 200 + (70 * 8),
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.fast),
                children: [buildTabPlaylist(context), buildTabAlbum(context)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabAlbum(BuildContext context) {
    return const ContainerNullValue(
      image: 'assets/images/library/album_none.png',
      title: 'You haven\'t created any albums yet.',
      subtitle:
          'Find and click the favorite button for the album to add it to the library.',
    );
  }

  Container buildTabPlaylist(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: SizedBox(
        height: 70 * 8,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding / 4, horizontal: defaultPadding),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius:
                          BorderRadius.circular(defaultBorderRadius / 2),
                    ),
                    child: const Center(
                      child: Icon(Ionicons.add, size: 30),
                    ),
                  ),
                  title: Text(
                    'Add playlist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              paddingHeight(1.5),
              Padding(
                padding: const EdgeInsets.only(left: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playlist suggest',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Heard a lot',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              paddingHeight(1),
              ...Iterable<int>.generate(5).map(
                (e) => SizedBox(
                  height: 70,
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      leading: Stack(children: [
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius / 2),
                            image: const DecorationImage(
                              image:
                                  AssetImage('assets/images/music_default.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius / 2),
                            image: const DecorationImage(
                              image: CachedNetworkImageProvider(
                                  'https://e-cdns-images.dzcdn.net/images/playlist/7ff3e69ac26739df33ff53cf31e7259b/250x250-000000-80-0-0.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ]),
                      title: Text(
                        'Giai điệu chữa lành',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        'Spotify',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Ionicons.heart_outline),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: const SizedBox(),
      leadingWidth: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider((isCheck &&
                    _auth.currentUser != null)
                ? '${_auth.currentUser!.photoURL}'
                : 'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg'),
            backgroundColor:
                Colors.grey, // fallback color if the image is not available
          ),
          paddingWidth(0.5),
          Text(
            'Your Library',
            style: Theme.of(context).textTheme.headlineSmall,
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Ionicons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Ionicons.add,
            size: 28,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  SizedBox buildListLibrary() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.fast),
        itemCount: categoryLibraries.length,
        itemBuilder: (context, index) {
          VoidCallback? onTap;
          if (categoryLibraries[index].code == CategoryLibrary.downloaded) {
            onTap = () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2) {
                    return const LayoutScreen(
                      index: 4,
                      screen: DownloadScreen(),
                    );
                  },
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            };
          }
          return GestureDetector(
            onTap: onTap ?? () {},
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(left: defaultPadding),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(defaultBorderRadius),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    categoryLibraries[index].image,
                    width: 40,
                  ),
                  paddingHeight(1),
                  Text(
                    categoryLibraries[index].title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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
                  ContainerNullValue(
                    image: 'assets/images/library/album_none.png',
                    title: 'You haven\'t downloaded any playlist yet.',
                    subtitle:
                        'Download your favorite playlist so you can play it when there is no internet connection.',
                  ),
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

class TabTrack extends StatefulWidget {
  const TabTrack({Key? key}) : super(key: key);

  @override
  State<TabTrack> createState() => _TabTrackState();
}

class _TabTrackState extends State<TabTrack> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TrackDownload>>(
      future: DownloadDBService.instance.getAllTrackDownloads(),
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
          List<Track> tracks = <Track>[];
          List<TrackDownload>? trackDownloads = snapshot.data;
          for (var item in trackDownloads!) {
            tracks.add(Track(
                id: int.parse(item.trackId.toString()),
                title: item.title,
                album:
                    Album(coverSmall: item.coverSmall, coverXl: item.coverXl),
                artist: Artist(
                    name: item.artistName,
                    pictureSmall: item.artistPictureSmall),
                preview: item.preview,
                type: item.type));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(0),
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == snapshot.data!.length) {
                return paddingHeight(9);
              }
              TrackDownload? item = snapshot.data![index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  DownloadDBService.instance.deleteTrackDownload(item.trackId!);
                  FlutterDownloader.remove(
                      taskId: item.taskId!, shouldDeleteContent: true);
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
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            child: CachedNetworkImage(
                              imageUrl: '${item.coverSmall}',
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
                                item.title.toString(),
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.artistName.toString(),
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
            separatorBuilder: (context, index) => paddingHeight(1),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
