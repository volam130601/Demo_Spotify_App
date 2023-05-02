import 'dart:async';

import 'package:demo_spotify_app/data/response/status.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/view_models/library/library_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category/category_search.dart';
import '../../models/firebase/playlist_new.dart';
import '../../models/track.dart';
import '../../view_models/layout_screen_view_model.dart';
import '../../view_models/search_view_model.dart';
import '../../widgets/list_tile_custom/track_suggest_tile.dart';

class BoxSearchTrack extends StatefulWidget {
  const BoxSearchTrack({Key? key, required this.playlistNew}) : super(key: key);
  final PlaylistNew playlistNew;

  @override
  State<BoxSearchTrack> createState() => _BoxSearchTrackState();
}

class _BoxSearchTrackState extends State<BoxSearchTrack> {
  final keyGlobal = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  final FocusNode _focusNode = FocusNode();

  String categoryCode = CategorySearch.tracks;
  Timer? _debounce;
  final Duration _searchDelay = const Duration(milliseconds: 500);

  @override
  void initState() {
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
    if (categoryCode == CategorySearch.tracks) {
      Provider.of<SearchViewModel>(context, listen: false)
          .fetchTracksApi(_searchText, 0, 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBody;
    double height = MediaQuery.of(context).size.height - 250;
    if (_searchText.isNotEmpty) {
      Widget contentBody = const SizedBox();
      final searchProvider =
          Provider.of<SearchViewModel>(context, listen: true);
      if (categoryCode == CategorySearch.tracks) {
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
              height: tracks!.length * 66,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => TrackSuggestTileItem(
                  track: tracks[index],
                  playlistNew: widget.playlistNew,
                ),
                itemCount: tracks.length,
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
          paddingHeight(1),
          contentBody,
        ],
      );
    } else {
      List<Track>? tracks =
          Provider.of<LibraryViewModel>(context, listen: false)
              .trackSuggests
              .data;
      searchBody = SizedBox(
        height: tracks!.length * (50 + 16),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tracks.length,
          itemBuilder: (context, index) => TrackSuggestTileItem(
            track: tracks[index],
            playlistNew: widget.playlistNew,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        showBottomBar(context);
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
            children: [searchBody, paddingHeight(8)],
          ),
        ),
      ),
    );
  }
}

void showBottomBar(BuildContext context) {
  FocusManager.instance.primaryFocus?.unfocus();
  Provider.of<LayoutScreenViewModel>(context, listen: false)
      .setIsShotBottomBar(true);
}
