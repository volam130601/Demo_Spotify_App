import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/network/firebase/favorite_playlist_service.dart';
import 'package:demo_spotify_app/data/network/firebase/playlist_new_service.dart';
import 'package:demo_spotify_app/models/album.dart';
import 'package:demo_spotify_app/models/firebase/favorite_playlist.dart';
import 'package:demo_spotify_app/models/firebase/playlist_new.dart';
import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/views/library/add_playlist.dart';
import 'package:demo_spotify_app/views/library/favorite_screen.dart';
import 'package:demo_spotify_app/widgets/list_tile_custom/list_tile_custom.dart';
import 'package:demo_spotify_app/widgets/tab_bar/tab_bar_custom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../data/network/firebase/favorite_album_service.dart';
import '../../models/artist.dart';
import '../../models/category/category_library.dart';
import '../../models/firebase/favorite_album.dart';
import '../../utils/constants/default_constant.dart';
import '../../widgets/container_null_value.dart';
import '../../widgets/selection_title.dart';
import '../layout_screen.dart';
import 'download_screen.dart';
import 'artist/follow_artist_screen.dart';

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SelectionTitle(title: 'Library'),
                  buildListLibrary(),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: StickyTabBarLibraryDelegate(
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
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              ),
            ),
            pinned: true,
          )
        ],
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.fast),
          children: [buildTabPlaylist(context), buildTabAlbum(context)],
        ),
      ),
    );
  }

  Widget buildTabAlbum(BuildContext context) {
    return StreamBuilder(
      stream: FavoriteAlbumService.instance
          .getAlbumItemsByUserId(userId: CommonUtils.userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ContainerNullValue(
            image: 'assets/images/library/album_none.png',
            title: 'You haven\'t created any albums yet.',
            subtitle:
                'Find and click the favorite button for the album to add it to the library.',
          );
        }
        List<FavoriteAlbum>? albumFavorite = snapshot.data!;
        List<Album> albums = [];
        for (var item in albumFavorite) {
          albums.add(
            Album(
                id: int.tryParse(item.albumId.toString()),
                title: item.title,
                artist: Artist(name: item.artistName),
                coverMedium: item.coverMedium),
          );
        }
        return SizedBox(
          height: albums.length * (50 + 16),
          child: ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return AlbumTileItem(album: albums[index]);
            },
          ),
        );
      },
    );
  }

  Widget buildTabPlaylist(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2) {
                    return const AddPlaylistScreen();
                  },
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                  paddingWidth(0.5),
                  Text(
                    'Add playlist',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: FavoritePlaylistService.instance
                .getPlaylistItemsByUserId(userId: CommonUtils.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              List<FavoritePlaylist>? playlistFavorite = snapshot.data!;
              List<Playlist> playlists = [];
              for (var item in playlistFavorite) {
                playlists.add(Playlist(
                    id: int.tryParse(item.playlistId.toString()),
                    title: item.title,
                    user: UserPlaylist(name: item.userName.toString()),
                    pictureMedium: item.pictureMedium));
              }
              return SizedBox(
                height: playlists.length * (50 + 16),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    return PlaylistTileItem(playlist: playlists[index]);
                  },
                ),
              );
            },
          ),
          StreamBuilder(
            stream: PlaylistNewService.instance
                .getItemsByUserId(CommonUtils.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              List<PlaylistNew>? playlistNews = snapshot.data!;
              playlistNews.sort((a, b) => a.title!.compareTo(b.title!));
              return SizedBox(
                height: playlistNews.length * (50 + 16),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: playlistNews.length,
                  itemBuilder: (context, index) {
                    return PlaylistNewTileItem(playlistNew: playlistNews[index]);
                  },
                ),
              );
            },
          ),
          paddingHeight(8),
        ],
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
          if (categoryLibraries[index].code == CategoryLibrary.favoriteSong) {
            onTap = () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2) {
                    return const LayoutScreen(
                      index: 4,
                      screen: FavoriteSongScreen(),
                    );
                  },
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            };
          }
          if (categoryLibraries[index].code == CategoryLibrary.artist) {
            onTap = () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation1,
                      Animation<double> animation2) {
                    return const LayoutScreen(
                      index: 4,
                      screen: FollowArtistScreen(),
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
