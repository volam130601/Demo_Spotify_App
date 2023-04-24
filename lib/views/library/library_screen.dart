import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/category/category_library.dart';
import '../../utils/constants/default_constant.dart';
import '../../widgets/container_null_value.dart';
import '../../widgets/selection_title.dart';
import '../layout_screen.dart';
import 'download_screen.dart';

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
