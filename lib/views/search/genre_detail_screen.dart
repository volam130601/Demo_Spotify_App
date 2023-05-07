import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/genre/genre_search.dart';
import 'package:demo_spotify_app/view_models/search/genre_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/default_constant.dart';
import '../../widgets/selection_title.dart';

class GenreDetail extends StatefulWidget {
  const GenreDetail({Key? key, required this.genreSearch}) : super(key: key);
  final GenreSearch genreSearch;

  @override
  State<GenreDetail> createState() => _GenreDetailState();
}

class _GenreDetailState extends State<GenreDetail> {
  late ScrollController _scrollController;
  bool isShow = false;

  @override
  void initState() {
    super.initState();
    Provider.of<GenreDetailViewModel>(context, listen: false)
        ..checkGenreId(widget.genreSearch.id!)
        ..fetchData(widget.genreSearch);
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

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GenreDetailViewModel>(
      builder:(context, value, child) {
       if(value.widgetsGenreList.isEmpty) {
         return Scaffold(
           body: Center(
             child: LoadingAnimationWidget.staggeredDotsWave(
               color: Colors.white,
               size: 40,
             ),
           ),
         );
       }
       List<Widget> widgetsGenreList = value.widgetsGenreList;
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
      } ,
    );
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
