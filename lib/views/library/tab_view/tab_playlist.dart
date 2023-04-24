import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/models/local/playlist_detail_download.dart';
import 'package:demo_spotify_app/models/local/playlist_download.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:demo_spotify_app/widgets/container_null_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../repository/local/download_repository.dart';

class TabPlaylist extends StatefulWidget {
  const TabPlaylist({Key? key}) : super(key: key);

  @override
  State<TabPlaylist> createState() => _TabPlaylistState();
}

class _TabPlaylistState extends State<TabPlaylist> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaylistDownload>>(
      future: DownloadRepository.instance.getAllPlaylistDownloads(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const ContainerNullValue(
              image: 'assets/images/library/album_none.png',
              title: 'You haven\'t downloaded any track yet.',
              subtitle:
                  'Download your favorite track so you can play it when there is no internet connection.',
            );
          }
          List<PlaylistDownload>? playlistDownloads = snapshot.data;
          return ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: const BouncingScrollPhysics(),
            itemCount: playlistDownloads!.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == snapshot.data!.length) {
                return paddingHeight(8);
              }
              PlaylistDownload item = playlistDownloads[index];
              return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  DownloadRepository.instance
                      .deletePlaylistDownload(item.playlistId!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/spotify_logo.svg',
                            width: 20,
                            height: 20,
                          ),
                          paddingWidth(0.5),
                          Text('Deleted playlistId ${item.playlistId} '),
                        ],
                      ),
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation1,
                            Animation<double> animation2) {
                          return LayoutScreen(
                            index: 4,
                            screen: PlaylistDetailDownload(
                              playlistDownload: item,
                            ),
                          );
                        },
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    height: 70,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            child: CachedNetworkImage(
                              imageUrl: '${item.pictureMedium}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.asset(
                                'assets/images/music_default.jpg',
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        paddingWidth(1),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.title.toString(),
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.userName.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: ElevatedButton(
                            onPressed: () async {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                            ),
                            child: const Center(
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
