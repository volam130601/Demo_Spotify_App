import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/network/firebase/favorite_song_service.dart';
import 'package:demo_spotify_app/models/firebase/favorite_song.dart';
import 'package:demo_spotify_app/models/local/track_download.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../models/track.dart';
import '../../../../utils/constants/default_constant.dart';
import '../../data/network/firebase/playlist_new_service.dart';
import '../../models/album.dart';
import '../../models/firebase/playlist_new.dart';
import '../../models/playlist.dart';
import '../../repository/local/download_repository.dart';
import '../../utils/colors.dart';
import '../../view_models/download_view_modal.dart';
import '../../views/home/detail/album_detail.dart';
import '../../views/home/detail/artist_detail.dart';
import '../../views/layout_screen.dart';
import '../../views/library/add_playlist.dart';
import '../list_tile_custom/list_tile_custom.dart';

class ActionMore extends StatefulWidget {
  const ActionMore({
    Key? key,
    required this.track,
    this.playlist,
    this.isDownloaded = false,
    this.album,
    this.isAddedFavorite,
    this.playlistNew,
  }) : super(key: key);
  final Track track;
  final Playlist? playlist;
  final Album? album;
  final bool? isDownloaded;
  final bool? isAddedFavorite;
  final PlaylistNew? playlistNew;

  @override
  State<ActionMore> createState() => _ActionMoreState();
}

class _ActionMoreState extends State<ActionMore> {
  int _value = 0;
  bool _isChecked = false;
  final _searchPlaylist = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    IsolateNameServer.lookupPortByName('downloader_track')
        ?.send([id, status.value, progress]);
  }

  @override
  Widget build(BuildContext context) {
    Track? track = widget.track;
    Widget downloadTileItem;
    Widget addFavoriteTileItem;
    Widget addPlaylistTileItem;
    if (widget.isDownloaded == true) {
      downloadTileItem = buildModalTileItem(
        context,
        title: 'Delete downloaded track',
        icon: const Icon(Ionicons.trash_outline),
        onTap: () async {
          Navigator.pop(context);
          DownloadRepository.instance.deleteTrackDownload(track.id!);
          Provider.of<DownloadViewModel>(context, listen: false)
              .removeTrackDownload(track.id!.toInt());
          TrackDownload trackDownload = await DownloadRepository.instance
              .getTrackById(track.id!.toString());
          await FlutterDownloader.remove(
              taskId: trackDownload.taskId.toString(),
              shouldDeleteContent: true);
          ToastCommon.showCustomText(content: 'Deleted from memory');
        },
      );
    } else {
      downloadTileItem = buildModalTileItem(
        context,
        title: 'Download this song',
        icon: const Icon(Icons.download_outlined),
        onTap: () async {
          Navigator.pop(context);
          int totalSize =
              await CommonUtils.getFileSize(track.preview.toString());
          // ignore: use_build_context_synchronously
          buildShowModalDownloadThisSong(context, track, totalSize);
        },
      );
    }
    if (widget.isAddedFavorite == true) {
      addFavoriteTileItem = buildModalTileItem(
        context,
        title: 'Added to the library',
        icon: Icon(
          Icons.favorite,
          color: ColorsConsts.primaryColorDark,
        ),
        onTap: removeFavoriteTrack(track),
      );
    } else {
      addFavoriteTileItem = buildModalTileItem(
        context,
        title: 'Add to the library',
        icon: const Icon(Icons.favorite_border_sharp),
        onTap: addFavoriteTrack(track),
      );
    }
    if (widget.playlistNew != null) {
      addPlaylistTileItem = buildModalTileItem(
        context,
        title: 'Remove from playlist',
        icon: Image.asset(
          'assets/icons/icons8-add-song-48.png',
          color: Colors.white,
          width: 20,
          height: 20,
        ),
        onTap: () {
          PlaylistNew? playlistNew = widget.playlistNew;
          List<Track> tracks = playlistNew!.tracks!;
          tracks.removeWhere((element) => element.id == track.id);
          PlaylistNewService.instance.updateItem(
            PlaylistNew(
              id: playlistNew.id,
              title: playlistNew.title,
              isDownloading: playlistNew.isDownloading,
              isPrivate: playlistNew.isDownloading,
              picture:
                  (tracks.isNotEmpty) ? tracks.first.album!.coverBig : null,
              releaseDate: playlistNew.releaseDate,
              userId: playlistNew.userId,
              tracks: tracks,
              userName: playlistNew.userName,
            ),
          );
          Navigator.pop(context);
        },
      );
    } else {
      addPlaylistTileItem = buildModalTileItem(context,
          title: 'Add to playlist',
          icon: Image.asset(
            'assets/icons/icons8-add-song-48.png',
            color: Colors.white,
            width: 20,
            height: 20,
          ), onTap: () {
        Navigator.of(context).pop(true);
        buildModalAddPlaylist(context);
      });
    }

    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          buildShowModalMore(context, track, downloadTileItem,
              addFavoriteTileItem, addPlaylistTileItem);
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0)),
        child: const Icon(Icons.more_vert),
      ),
    );
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
                Text(
                  'Add track to the playlist',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                buildDivider(),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                    stream: PlaylistNewService.instance
                        .getItemsByUserId(CommonUtils.userId),
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

  Future<dynamic> buildShowModalMore(
      BuildContext context,
      Track track,
      Widget downloadTileItem,
      Widget addFavoriteTileItem,
      Widget addPlaylistTileItem) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * .5,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(defaultBorderRadius),
              topRight: Radius.circular(defaultBorderRadius),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                paddingHeight(0.5),
                buildHeaderModal(track, context),
                buildDivider(),
                downloadTileItem,
                addFavoriteTileItem,
                addPlaylistTileItem,
                buildModalTileItem(
                  context,
                  title: 'View Album',
                  icon: Image.asset(
                    'assets/icons/icons8-disk-24.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(true);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return LayoutScreen(
                            index: 4,
                            screen: AlbumDetail(albumId: track.album!.id!),
                          );
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                buildModalTileItem(
                  context,
                  title: 'View Artist',
                  icon: Image.asset(
                    'assets/icons/icons8-artist-25.png',
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(true);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return LayoutScreen(
                            index: 4,
                            screen: ArtistDetail(artistId: track.artist!.id!),
                          );
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                paddingHeight(1),
              ],
            ),
          ),
        );
      },
    );
  }

  VoidCallback removeFavoriteTrack(Track track) {
    return () {
      ToastCommon.showCustomText(
          content: 'Removed track ${track.title} from the library');
      FavoriteSongService.instance.deleteItemByTrackId(
          track.id.toString(), FirebaseAuth.instance.currentUser!.uid);
    };
  }

  VoidCallback addFavoriteTrack(Track track) {
    return () {
      ToastCommon.showCustomText(
          content: 'Added track ${track.title} to the library');
      FavoriteSongService.instance.addItem(
        (widget.album != null)
            ? FavoriteSong(
                id: DateTime.now().toString(),
                trackId: track.id.toString(),
                albumId: widget.album!.id.toString(),
                artistId: track.artist!.id.toString(),
                title: track.title,
                albumTitle: widget.album!.title.toString(),
                artistName: track.artist!.name,
                pictureMedium: track.artist!.pictureMedium,
                coverMedium: widget.album!.coverMedium.toString(),
                coverXl: widget.album!.coverXl.toString(),
                preview: track.preview,
                releaseDate: widget.album!.releaseDate.toString(),
                userId: FirebaseAuth.instance.currentUser!.uid,
                type: 'track',
              )
            : FavoriteSong(
                id: DateTime.now().toString(),
                trackId: track.id.toString(),
                albumId: track.album!.id.toString(),
                artistId: track.artist!.id.toString(),
                title: track.title,
                albumTitle: track.album!.title,
                artistName: track.artist!.name,
                pictureMedium: track.artist!.pictureMedium,
                coverMedium: track.album!.coverMedium,
                coverXl: track.album!.coverXl,
                preview: track.preview,
                releaseDate: track.album!.releaseDate,
                userId: FirebaseAuth.instance.currentUser!.uid,
                type: 'track',
              ),
      );
    };
  }

  Future<dynamic> buildShowModalDownloadThisSong(
      BuildContext context, Track track, int totalSize) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Container(
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(defaultBorderRadius),
              ),
            ),
            child: Column(
              children: [
                paddingHeight(0.5),
                buildHeaderModal(track, context),
                const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Divider(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn chất lượng tải',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      paddingHeight(1),
                      buildChooseDownloadQuality(setState, context,
                          tagName: 'SQ',
                          title: 'Chất lượng tiêu chuẩn',
                          subTitle: 'Tiết kiệm dung lượng bộ nhớ',
                          index: 0),
                      buildChooseDownloadQuality(setState, context,
                          tagName: 'HQ',
                          title: 'Chất lượng cao',
                          subTitle: 'Tốt nhất cho tai nghe và loa',
                          index: 1),
                      const Divider(),
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            checkColor: Colors.black,
                            activeColor: ColorsConsts.primaryColorDark,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          Text(
                            'Lưu lựa chọn chất lượng và không hỏi lại',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop(true);
                            final status = await Permission.storage.request();
                            if (status.isGranted) {
                              final externalDir =
                                  await getExternalStorageDirectory();
                              if (widget.playlist != null) {
                                await DownloadRepository.instance
                                    .insertPlaylistDownload(widget.playlist!);
                                await DownloadRepository.instance
                                    .insertTrackDownload(
                                        track: track,
                                        playlistId: widget.playlist!.id);
                              } else if (widget.album != null) {
                                await DownloadRepository.instance
                                    .insertAlbumDownload(widget.album!,
                                        track: track);
                                await DownloadRepository.instance
                                    .insertTrackDownload(
                                        track: track, album: widget.album);
                              }
                              await FlutterDownloader.enqueue(
                                url: '${track.preview}',
                                savedDir: externalDir!.path,
                                fileName: 'track-${track.id}.mp3',
                                showNotification: false,
                                openFileFromNotification: false,
                              );
                              ToastCommon.showCustomText(
                                  content: 'Add track to downloaded list.');
                            } else {
                              log("Permission denied");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: Text(
                            'TẢI XUỐNG (${CommonUtils.formatSize(totalSize)})',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultPadding, right: defaultPadding, top: defaultPadding),
      child: Divider(
        color: Colors.grey.shade600,
      ),
    );
  }

  SizedBox buildHeaderModal(Track? track, BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            child: CachedNetworkImage(
              imageUrl: (widget.album != null)
                  ? '${widget.album!.coverMedium}'
                  : '${track!.album!.coverSmall}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.asset(
                'assets/images/music_default.jpg',
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        title: Text(
          '${track!.title}',
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              '${track.artist!.name}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined),
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

  InkWell buildChooseDownloadQuality(StateSetter setState, BuildContext context,
      {required String tagName,
      required String title,
      required String subTitle,
      required int index}) {
    return InkWell(
      onTap: () {
        setState(() {
          _value = index;
        });
      },
      child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: Container(
            width: 40,
            height: 35,
            padding: const EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultBorderRadius / 2),
                  border: Border.all(width: 1, color: Colors.white)),
              child: Center(
                child: Text(
                  tagName,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(),
                ),
              ),
            ),
          ),
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            subTitle,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          trailing: (_value == index)
              ? Icon(
                  Icons.radio_button_checked,
                  color: ColorsConsts.primaryColorDark,
                )
              : const Icon(Icons.radio_button_off)),
    );
  }
}
