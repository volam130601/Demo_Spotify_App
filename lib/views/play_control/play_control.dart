import 'package:demo_spotify_app/data/network/firebase/comment_service.dart';
import 'package:demo_spotify_app/views/play_control/comment/comment_box.dart';
import 'package:demo_spotify_app/widgets/action/modal_download_track.dart';
import 'package:demo_spotify_app/widgets/navigator/slide_animation_page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/default_constant.dart';
import '../../../widgets/play_control/seekbar.dart';
import '../../data/network/firebase/favorite_song_service.dart';
import '../../models/album.dart';
import '../../models/firebase/favorite_song.dart';
import '../../models/track.dart';
import '../../utils/colors.dart';
import '../../utils/common_utils.dart';
import '../../utils/toast_utils.dart';
import '../../view_models/track_play/multi_control_player_view_model.dart';
import 'control_music_buttons.dart';

class PlayControl extends StatelessWidget {
  const PlayControl({Key? key, required this.track, required this.album})
      : super(key: key);
  final Track track;
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiPlayerViewModel>(
      builder: (context, value, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                          elevation: 0, padding: const EdgeInsets.all(0)),
                      icon: Icon(
                        Ionicons.share_social_outline,
                        color: Colors.grey.shade300,
                      )),
                  const Spacer(),
                  StreamBuilder(
                    stream: FavoriteSongService.instance.getItemsByUserId(
                        FirebaseAuth.instance.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Ionicons.heart_outline),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(0)),
                                onPressed: () {},
                                child: const Icon(Icons.more_vert),
                              ),
                            )
                          ],
                        );
                      }
                      final isAddedFavorite = snapshot.data!.any(
                          (element) => element.trackId == track.id.toString());
                      return SizedBox(
                        width: 50,
                        child: isAddedFavorite
                            ? IconButton(
                                onPressed: removeFavoriteTrack(track),
                                icon: Icon(
                                  Ionicons.heart,
                                  color: ColorsConsts.primaryColorDark,
                                ),
                              )
                            : IconButton(
                                onPressed: addFavoriteTrack(track),
                                icon: const Icon(Ionicons.heart_outline)),
                      );
                    },
                  ),
                ],
              ),
            ),
            StreamBuilder<PositionData>(
              stream: value.positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: value.player.seek,
                );
              },
            ),
            ControlMusicButtons(player: value.player),
            paddingHeight(1.5),
            buildListMoreActions(context, value),
          ],
        );
      },
    );
  }

  Widget buildListMoreActions(
      BuildContext context, MultiPlayerViewModel value) {
    return StreamBuilder<SequenceState?>(
      stream: value.player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const Icon(Ionicons.chatbox_outline);
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: CommentService.instance
                    .getTotalCommentByTrackId(metadata.id),
                builder: (context, snapshot) {
                  return Stack(children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          SlideTopPageRoute(
                            page: CommentBoxScreen(
                              trackId: metadata.id,
                            ),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                          elevation: 0, padding: const EdgeInsets.all(0)),
                      icon: Icon(Ionicons.chatbox_outline,
                          color: Colors.grey.shade300),
                    ),
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Text(
                          snapshot.data != null
                              ? '${CommonUtils.convertToShorthand(snapshot.data!)}+'
                              : '',
                          style: Theme.of(context).textTheme.labelSmall,
                        ))
                  ]);
                },
              ),
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                    elevation: 0, padding: const EdgeInsets.all(0)),
                icon: Image.asset(
                  'assets/icons/icons8-add-song-48.png',
                  color: Colors.grey.shade300,
                  width: 25,
                  height: 25,
                ),
              ),
              ModalDownloadTrack(
                context: context,
                track: track,
                album: album,
                isIconButton: true,
              ),
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                    elevation: 0, padding: const EdgeInsets.all(0)),
                icon: Image.asset(
                  'assets/icons/icons8-disk-24.png',
                  color: Colors.grey.shade300,
                  width: 25,
                  height: 25,
                ),
              ),
            ],
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
      FavoriteSongService.instance.addItem(FavoriteSong(
        id: DateTime.now().toString(),
        trackId: track.id.toString(),
        albumId: album.id.toString(),
        artistId: track.artist!.id.toString(),
        title: track.title,
        albumTitle: album.title.toString(),
        artistName: track.artist!.name,
        pictureMedium: track.artist!.pictureMedium,
        coverMedium: album.coverMedium.toString(),
        coverXl: album.coverXl.toString(),
        preview: track.preview,
        releaseDate: album.releaseDate.toString(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        type: 'track',
      ));
    };
  }
}
