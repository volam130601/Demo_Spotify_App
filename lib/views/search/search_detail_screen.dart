import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/category.dart';
import 'package:demo_spotify_app/models/playlist.dart';
import 'package:demo_spotify_app/res/colors.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../data/response/status.dart';
import '../../models/album.dart';
import '../../models/artist.dart';
import '../../models/firebase/recent_search.dart';
import '../../models/track.dart';
import '../../res/constants/default_constant.dart';
import '../../services/firebase/recent_search_service.dart';
import '../../view_models/multi_control_player_view_model.dart';
import '../../view_models/track_play_view_model.dart';
import '../home/components/list_tile_item.dart';
import '../home/detail/album_detail.dart';
import '../home/detail/artist_detail.dart';
import '../home/detail/playlist_detail.dart';
import '../layout_screen.dart';

class BoxSearch extends StatefulWidget {
  const BoxSearch({Key? key}) : super(key: key);

  @override
  State<BoxSearch> createState() => _BoxSearchState();
}

class _BoxSearchState extends State<BoxSearch> {
  final keyGlobal = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  final FocusNode _focusNode = FocusNode();
  final RecentSearchService _recentSearchService = RecentSearchService();

  int _selectIndex = 0;
  String categoryCode = Category.tracks;
  Timer? _debounce;
  final Duration _searchDelay = const Duration(milliseconds: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_onTextChanged);
    _focusNode.addListener(_hideBottomBar);
  }

  void _onTextChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchText = "";
      });
    }
  }

  void _clearSearchText() {
    setState(() {
      _searchController.clear();
    });
  }

  void _hideBottomBar() {
    if (_focusNode.hasFocus) {
      Provider.of<LayoutScreenViewModel>(context, listen: false)
          .setIsShotBottomBar(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onTextChanged);
    _searchController.dispose();
    _focusNode.removeListener(_hideBottomBar);
    _focusNode.dispose();
  }

  void callApiSearch() {
    if (categoryCode == Category.tracks) {
      Provider.of<SearchViewModel>(context, listen: false)
          .fetchTracksApi(_searchText, 0, 50);
    } else if (categoryCode == Category.artists) {
      Provider.of<SearchViewModel>(context, listen: false)
          .fetchArtistsApi(_searchText, 0, 50);
    } else if (categoryCode == Category.albums) {
      Provider.of<SearchViewModel>(context, listen: false)
          .fetchAlbumsApi(_searchText, 0, 50);
    } else if (categoryCode == Category.playlists) {
      Provider.of<SearchViewModel>(context, listen: false)
          .fetchPlaylistsApi(_searchText, 0, 50);
    }
  }

  void showBottomBar() {
    FocusManager.instance.primaryFocus?.unfocus();
    Provider.of<LayoutScreenViewModel>(context, listen: false)
        .setIsShotBottomBar(true);
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBody;
    double height = MediaQuery.of(context).size.height - 250;
    if (_searchText.isNotEmpty) {
      Widget contentBody = const SizedBox();
      final searchProvider =
          Provider.of<SearchViewModel>(context, listen: true);
      if (categoryCode == Category.tracks) {
        switch (searchProvider.tracks.status) {
          case Status.LOADING:
            contentBody = SizedBox(
              height: height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          case Status.COMPLETED:
            List<Track>? tracks = searchProvider.tracks.data;
            contentBody = SizedBox(
              height: height,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => ListTileItem(
                  image: '${tracks[index].album!.coverSmall}',
                  title: '${tracks[index].title}',
                  subTitle: '${tracks[index].type}',
                  isTrack: true,
                  onTap: () async {
                    showBottomBar();
                    var trackPlayVM =
                        Provider.of<TrackPlayViewModel>(context, listen: false);
                    var multiPlayerVM = Provider.of<MultiPlayerViewModel>(
                        context,
                        listen: false);
                    await trackPlayVM.fetchTracksPlayControl(
                      albumID: tracks[index].album!.id as int,
                      index: 0,
                      limit: 20,
                    );
                    int? trackIndex = trackPlayVM.tracksPlayControl.data!
                        .indexWhere((track) => track.id == tracks[index].id);

                    await multiPlayerVM.initState(
                        tracks: trackPlayVM.tracksPlayControl.data!,
                        albumId: tracks[index].album!.id as int,
                        artist: tracks[index].artist,
                        index: trackIndex);

                    _recentSearchService.addItem(RecentSearchItem(
                      id: DateTime.now().toString(),
                      itemId: '${tracks[index].album!.id}',
                      title: '${tracks[index].title}',
                      image: '${tracks[index].album!.coverSmall}',
                      type: '${tracks[index].type}',
                    ));
                  },
                ),
                itemCount: tracks!.length,
              ),
            );
            break;
          case Status.ERROR:
            break;
          default:
            break;
        }
      }
      if (categoryCode == Category.artists) {
        switch (searchProvider.artists.status) {
          case Status.LOADING:
            contentBody = SizedBox(
              height: height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          case Status.COMPLETED:
            List<Artist>? artists = searchProvider.artists.data;
            contentBody = SizedBox(
              height: height,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTileItem(
                    image: '${artists[index].pictureSmall}',
                    title: '${artists[index].name}',
                    isArtist: true,
                    onTap: () async {
                      showBottomBar();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                              Animation<double> animation1,
                              Animation<double> animation2) {
                            return LayoutScreen(
                              index: 4,
                              screen: ArtistDetail(artist: artists[index]),
                            );
                          },
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );

                      _recentSearchService.addItem(RecentSearchItem(
                        id: DateTime.now().toString(),
                        itemId: '${artists[index].id}',
                        title: '${artists[index].name}',
                        image: '${artists[index].pictureSmall}',
                        type: '${artists[index].type}',
                      ));
                    },
                  );
                },
                itemCount: artists!.length,
              ),
            );
            break;
          case Status.ERROR:
            break;
          default:
            break;
        }
      }
      if (categoryCode == Category.playlists) {
        switch (searchProvider.playlists.status) {
          case Status.LOADING:
            contentBody = SizedBox(
              height: height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          case Status.COMPLETED:
            List<Playlist>? playlists = searchProvider.playlists.data;
            contentBody = Container(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: GridView.builder(
                itemCount: playlists!.length,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                  mainAxisExtent: 260,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      showBottomBar();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                              Animation<double> animation1,
                              Animation<double> animation2) {
                            return LayoutScreen(
                              index: 4,
                              screen: PlaylistDetail(
                                playlist: playlists[index],
                              ),
                            );
                          },
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                      _recentSearchService.addItem(RecentSearchItem(
                        id: DateTime.now().toString(),
                        itemId: '${playlists[index].id}',
                        title: '${playlists[index].title}',
                        image: '${playlists[index].pictureSmall}',
                        type: '${playlists[index].type}',
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          child: CachedNetworkImage(
                            imageUrl: playlists[index].pictureMedium as String,
                            placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                        paddingHeight(0.5),
                        Text(
                          '${playlists[index].title}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
            break;
          case Status.ERROR:
            break;
          default:
            break;
        }
      }
      if (categoryCode == Category.albums) {
        switch (searchProvider.albums.status) {
          case Status.LOADING:
            contentBody = SizedBox(
              height: height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
            break;
          case Status.COMPLETED:
            List<Album>? albums = searchProvider.albums.data;
            contentBody = Container(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: albums!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: defaultPadding,
                  mainAxisSpacing: defaultPadding,
                  mainAxisExtent: 260,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      showBottomBar();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                              Animation<double> animation1,
                              Animation<double> animation2) {
                            return LayoutScreen(
                              index: 4,
                              screen: AlbumDetail(
                                album: albums[index],
                              ),
                            );
                          },
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );

                      _recentSearchService.addItem(RecentSearchItem(
                        id: DateTime.now().toString(),
                        itemId: '${albums[index].id}',
                        title: '${albums[index].title}',
                        image: '${albums[index].coverSmall}',
                        type: '${albums[index].type}',
                      ));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CachedNetworkImage(
                            imageUrl: albums[index].coverMedium as String,
                            placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                        paddingHeight(0.5),
                        Text(
                          '${albums[index].title}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${albums[index].artist!.name}',
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
            break;
          case Status.ERROR:
            break;
          default:
            break;
        }
      }
      searchBody = Column(
        children: [
          buildListCategory(),
          paddingHeight(1),
          contentBody,
        ],
      );
    } else {
      searchBody = const RecentSearch();
    }

    return GestureDetector(
      onTap: () {
        showBottomBar();
      },
      child: Scaffold(
        key: keyGlobal,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _clearSearchText();
              Provider.of<LayoutScreenViewModel>(context, listen: false)
                  .setIsShotBottomBar(true);
              Navigator.pop(context);
            },
          ),
          title: TextField(
            focusNode: _focusNode,
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchText = _searchController.text;
              });
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(_searchDelay, () {
                callApiSearch();
              });
            },
            onSubmitted: (value) {
              Provider.of<LayoutScreenViewModel>(context, listen: false)
                  .setIsShotBottomBar(true);
            },
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'What do you want to listen to?',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: _clearSearchText,
                    )
                  : null,
              border: InputBorder.none,
              hintStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
            ),
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [paddingHeight(1), searchBody, paddingHeight(8)],
          ),
        ),
      ),
    );
  }

  SizedBox buildListCategory() {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: defaultPadding / 2),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectIndex = index;
                  categoryCode = categories[index].code;
                  callApiSearch();
                });
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                side: const BorderSide(color: Colors.grey),
                backgroundColor: (_selectIndex == index)
                    ? ColorsConsts.primaryColorDark
                    : Colors.transparent,
              ),
              child: Text(
                categories[index].name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
          );
        },
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class RecentSearch extends StatefulWidget {
  const RecentSearch({Key? key}) : super(key: key);

  @override
  State<RecentSearch> createState() => _RecentSearchState();
}

class _RecentSearchState extends State<RecentSearch> {
  final RecentSearchService _recentSearchService = RecentSearchService();
  bool? isClear = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RecentSearchItem>>(
      stream: _recentSearchService.getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }

        List<RecentSearchItem>? data = snapshot.data!.reversed.toList();
        if (data.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Play what you love',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Search for artists, songs, albums, and more.',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                'Recent searches',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(
              height: (data.length > 9)
                  ? MediaQuery.of(context).size.height - 350
                  : ((data.length) * 60),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return buildRecentSearchItem(
                        context, data[index], (data.first.id == data.last.id));
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: TextButton(
                onPressed: () {
                  _recentSearchService.deleteAll();
                },
                child: Text(
                  'Clear recent searches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorsConsts.primaryColorDark,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            paddingHeight(6),
          ],
        );
      },
    );
  }

  Widget buildRecentSearchItem(
      BuildContext context, RecentSearchItem item, bool checkData) {
    return SizedBox(
      height: 60,
      child: ListTile(
        leading: SizedBox(
          height: 50,
          width: 50,
          child: CachedNetworkImage(
            imageUrl: item.image,
            placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
        title: Container(
          margin: const EdgeInsets.only(bottom: defaultPadding / 2),
          child: Text(
            item.title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          item.type,
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: () {
            if (checkData) {
              setState(() {
                isClear = true;
              });
            }
            _recentSearchService.deleteItem(item.id);
          },
          icon: const Icon(Ionicons.close),
        ),
      ),
    );
  }
}
