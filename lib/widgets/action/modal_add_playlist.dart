import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../models/track.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../models/firebase/playlist_new.dart';
import '../../repository/remote/firebase/playlist_new_repository.dart';
import '../../views/library/add_playlist.dart';
import '../list_tile_custom/list_tile_custom.dart';

class ModalAddPlaylist extends StatefulWidget {
  const ModalAddPlaylist(
      {Key? key, required this.track, this.isIconButton = false})
      : super(key: key);
  final Track track;
  final bool isIconButton;

  @override
  State<ModalAddPlaylist> createState() => _ModalAddPlaylistState();
}

class _ModalAddPlaylistState extends State<ModalAddPlaylist> {
  final _searchPlaylist = TextEditingController();
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    if (!widget.isIconButton) {
      return buildModalTileItem(context,
          title: 'Add to playlist',
          icon: Image.asset('assets/icons/icons8-add-song-48.png',
              color: Colors.white, width: 20, height: 20), onTap: () {
        Navigator.of(context).pop(true);
        buildModalAddPlaylist(context);
      });
    } else {
      return IconButton(
        onPressed: () {
          buildModalAddPlaylist(context);
        },
        style: IconButton.styleFrom(
            elevation: 0, padding: const EdgeInsets.all(0)),
        icon: Image.asset(
          'assets/icons/icons8-add-song-48.png',
          color: Colors.grey.shade300,
          width: 25,
          height: 25,
        ),
      );
    }
  }

  Future<dynamic> buildModalAddPlaylist(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          margin: const EdgeInsets.only(top: defaultPadding * 2),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                  child: Text(
                    'Add track to the playlist',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(defaultBorderRadius * 4),
                    color: Colors.grey.shade800,
                  ),
                  child: TextField(
                    controller: _searchPlaylist,
                    onChanged: (value) {
                      setState(() {
                        _searchText = _searchPlaylist.text;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Ionicons.search),
                      hintText: 'Search playlist',
                    ),
                  ),
                ),
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
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: StreamBuilder(
                    stream: PlaylistNewRepository.instance.getPlaylistNews(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      List<PlaylistNew>? playlistNews = snapshot.data!;
                      if (_searchText.isNotEmpty) {
                        List<PlaylistNew>? result = playlistNews
                            .where((element) =>
                                element.title!.contains(_searchText))
                            .toList();
                        return SizedBox(
                          height: result.length * (50 + 16),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: result.length,
                            itemBuilder: (context, index) {
                              return AddTrackToPlaylistTileItem(
                                playlistNew: result[index],
                                track: widget.track,
                              );
                            },
                          ),
                        );
                      }
                      playlistNews.sort((a, b) => a.title!.compareTo(b.title!));
                      return SizedBox(
                        height: playlistNews.length * (50 + 16),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: playlistNews.length,
                          itemBuilder: (context, index) {
                            return AddTrackToPlaylistTileItem(
                              playlistNew: playlistNews[index],
                              track: widget.track,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildModalTileItem(BuildContext context,
      {String title = '', Widget? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: 60, child: icon),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
