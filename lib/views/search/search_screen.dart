import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/response/status.dart';
import 'package:demo_spotify_app/models/genre/genre_search.dart';
import 'package:demo_spotify_app/view_models/search_view_model.dart';
import 'package:demo_spotify_app/views/layout/layout_screen.dart';
import 'package:demo_spotify_app/views/search/genre_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/default_constant.dart';
import 'search_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setIsLoading();
    Provider.of<SearchViewModel>(context, listen: false)
        .fetchGenreSearchesApi();
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
        body: Consumer<SearchViewModel>(
          builder: (context, value, child) {
            switch (value.genreSearches.status) {
              case Status.LOADING:
                return Scaffold(
                  body: Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              case Status.COMPLETED:
                return buildBody(context, value);
              case Status.ERROR:
                return Text(value.genreSearches.toString());
              default:
                return const Text('Default Switch');
            }
          },
        ),
      );
    }
  }

  CustomScrollView buildBody(BuildContext context, SearchViewModel value) {
    List<GenreSearch>? genreSearches = value.genreSearches.data;
    return CustomScrollView(
      slivers: [
        buildHeaderBody(context),
        SliverPadding(
          padding: const EdgeInsets.only(
              top: defaultPadding,
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding * 6),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return LayoutScreen(
                              index: 4,
                              screen: GenreDetail(
                                genreSearch: genreSearches[index],
                              ));
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                genreSearches[index]
                                    .radios![0]
                                    .pictureMedium
                                    .toString()),
                            fit: BoxFit.cover),
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius / 2)),
                    child: Center(
                      child: Text(
                        '${genreSearches[index].title}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                );
              },
              childCount: genreSearches!.length,
            ),
          ),
        ),
      ],
    );
  }

  SliverPadding buildHeaderBody(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            paddingHeight(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Search',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined))
              ],
            ),
            buildBoxSearchBtn(context),
            Text(
              'Browser all',
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoxSearchBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return const LayoutScreen(
                index: 4,
                screen: BoxSearch(),
              );
            },
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        margin: const EdgeInsets.symmetric(vertical: defaultPadding),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(defaultBorderRadius / 2)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Ionicons.search, color: Colors.black),
            paddingWidth(1),
            Text(
              'What do you want to listen to?',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
