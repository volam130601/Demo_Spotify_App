import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/response/status.dart';
import 'package:demo_spotify_app/models/firebase/follow_artist.dart';
import 'package:demo_spotify_app/utils/colors.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../models/artist.dart';
import '../../../repository/remote/firebase/follow_artist_repository.dart';
import '../../../view_models/library/follow_artist_view_model.dart';

class MoreArtists extends StatefulWidget {
  const MoreArtists({Key? key, this.followArtist}) : super(key: key);
  final FollowArtist? followArtist;

  @override
  State<MoreArtists> createState() => _MoreArtistsState();
}

class _MoreArtistsState extends State<MoreArtists> {
  final _searchArtist = TextEditingController();
  String _searchText = '';
  List<Artist> selectedArtists = [];
  Timer? _debounce;
  final Duration _searchDelay = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    if (widget.followArtist != null) {
      setState(() {
        selectedArtists = widget.followArtist!.artists!;
      });
    }
    Provider.of<FollowArtistViewModel>(context, listen: false)
        .fetchSearchArtists('a', 0, 100);
  }

  @override
  void dispose() {
    super.dispose();
    _searchArtist.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.close),
        ),
        title: Text(
          'More artists',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(defaultBorderRadius * 4),
              color: Colors.grey.shade800,
            ),
            child: TextField(
              controller: _searchArtist,
              onChanged: (value) {
                setState(() {
                  _searchText = _searchArtist.text;
                });
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(_searchDelay, () {
                  Provider.of<FollowArtistViewModel>(context, listen: false)
                      .fetchSearchArtists(_searchText, 0, 50);
                });
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Ionicons.search),
                hintText: 'Search artist',
              ),
            ),
          ),
        ),
      ),
      body: Consumer<FollowArtistViewModel>(
        builder: (context, value, child) {
          switch (value.artists.status) {
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
              List<Artist> artists = value.artists.data!;
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: defaultPadding),
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  mainAxisExtent: 180,
                                  mainAxisSpacing: defaultPadding,
                                  crossAxisSpacing: defaultPadding),
                          itemCount: artists.length,
                          itemBuilder: (BuildContext ctx, index) {
                            Artist artist = artists[index];
                            bool isChoose = selectedArtists
                                .any((element) => element.id == artist.id);
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (!isChoose) {
                                      setState(() {
                                        selectedArtists.add(artist);
                                      });
                                    } else {
                                      setState(() {
                                        selectedArtists.remove(artist);
                                      });
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: CircleAvatar(
                                          radius: 50,
                                          foregroundImage:
                                              CachedNetworkImageProvider(
                                                  artist.pictureBig.toString()),
                                          backgroundImage: const AssetImage(
                                              "assets/images/music_default.jpg"),
                                        ),
                                      ),
                                      if (isChoose) ...{
                                        Container(
                                          width: 150,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: ColorsConsts
                                                      .primaryColorLight),
                                              shape: BoxShape.circle),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Icon(
                                            Ionicons.heart_circle_sharp,
                                            color:
                                                ColorsConsts.primaryColorLight,
                                          ),
                                        ),
                                      }
                                    ],
                                  ),
                                ),
                                paddingHeight(0.5),
                                Text(
                                  artist.name.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: isChoose
                                              ? ColorsConsts.primaryColorLight
                                              : Colors.white),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(defaultPadding * 2),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.followArtist != null) {
                          FollowArtistRepository.instance.addMoreFollowArtist(
                              followArtist: widget.followArtist!,
                              artists: selectedArtists);
                        } else {
                          FollowArtistRepository.instance
                              .addFollowArtist(artists: selectedArtists);
                        }
                        ToastCommon.showCustomText(
                            content: 'Following more artists success!');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding)),
                      child: Text(
                        'DONE',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ],
              );
            case Status.ERROR:
              return Text(value.artists.toString());
            default:
              return const Text('Default Switch');
          }
        },
      ),
    );
  }
}
