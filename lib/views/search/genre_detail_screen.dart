import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/genre/genre_search.dart';
import 'package:demo_spotify_app/view_models/search_view_model.dart';
import 'package:demo_spotify_app/views/home/components/card_item_custom.dart';
import 'package:demo_spotify_app/views/home/components/selection_title.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../models/track.dart';
import '../../utils/constants/default_constant.dart';
import '../../view_models/multi_control_player_view_model.dart';
import '../../widgets/slide_animation_page_route.dart';
import '../home/play_control/track_play.dart';

class GenreDetail extends StatefulWidget {
  const GenreDetail({Key? key, required this.genreSearch}) : super(key: key);
  final GenreSearch genreSearch;

  @override
  State<GenreDetail> createState() => _GenreDetailState();
}

class _GenreDetailState extends State<GenreDetail> {
  late ScrollController _scrollController;
  bool isShow = false;
  bool isLoading = true;

  List<Widget> widgetsGenreList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    setIsLoading();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >= (200 - kToolbarHeight)) {
          setState(() {
            isShow = true;
          });
        } else {
          setState(() {
            isShow = false;
          });
        }
      });
  }

  Future<void> _fetchData() async {
    SearchViewModel searchViewModel = SearchViewModel();
    for (int i = 0; i < widget.genreSearch.radios!.length; i++) {
      var item = widget.genreSearch.radios![i];
      await searchViewModel.fetchTrackTopsByGenreIdApi(
          item.id.toString(), 0, 5);
      if (searchViewModel.tracks.data!.isNotEmpty) {
        List<Track> tracks = searchViewModel.tracks.data!;
        setState(() {
          widgetsGenreList.add(SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                return CardItemCustom(
                  image: tracks[index].album!.coverMedium as String,
                  titleTop: tracks[index].title,
                  titleBottom: tracks[index].artist!.name,
                  centerTitle: true,
                  onTap: () async {
                    var multiPlayerVM = Provider.of<MultiPlayerViewModel>(
                        context,
                        listen: false);
                    await multiPlayerVM.initState(
                        tracks: tracks,
                        index: index);
                    //ignore: use_build_context_synchronously
                    Navigator.push(
                        context, SlideTopPageRoute(page: const TrackPlay()));
                  },

                );
              },
            ),
          ));
        });
      }
    }
  }

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 40,
          ),
        ),
      );
    } else {
      return Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            buildSliverAppBar(context),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: defaultPadding),
                    child: Column(
                      children: [
                        SelectionTitle(
                            title: widget.genreSearch.radios![index].title
                                as String),
                        widgetsGenreList[index],
                      ],
                    ),
                  );
                },
                childCount: widgetsGenreList.length,
              ),
            ),
            SliverToBoxAdapter(
              child: paddingHeight(8),
            )
          ],
        ),
      );
    }
  }

  SliverAppBar buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.genreSearch.title as String,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        centerTitle: isShow,
        titlePadding: const EdgeInsets.only(left: 10, bottom: 10),
        expandedTitleScale: 2,
        background: CachedNetworkImage(
          imageUrl: widget.genreSearch.radios![0].pictureMedium.toString(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
