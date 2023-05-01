import 'package:demo_spotify_app/data/network/firebase/playlist_new_service.dart';
import 'package:demo_spotify_app/utils/colors.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:uuid/uuid.dart';

import '../../models/firebase/playlist_new.dart';
import '../layout_screen.dart';
import 'add_playlist_detail_screen.dart';

class AddPlaylistScreen extends StatefulWidget {
  const AddPlaylistScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaylistScreen> createState() => _AddPlaylistScreenState();
}

class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
  final _playlistNameController = TextEditingController();
  bool _isDownloading = false;
  bool _isPrivate = false;
  String _errorText = '';

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
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: TextFormField(
              controller: _playlistNameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Playlist Name',
                hintText: 'Enter name of the playlist',
                errorText: (_errorText.isNotEmpty) ? _errorText : null,
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorsConsts.primaryColorDark),
                ),
              ),
            ),
          ),
          paddingHeight(2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              children: [
                Text(
                  'Add downloading',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                  value: _isDownloading,
                  activeColor: ColorsConsts.primaryColorLight,
                  onChanged: (value) {
                    setState(() {
                      _isDownloading = value;
                    });
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Row(
              children: [
                Text(
                  'Private',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Switch(
                  value: _isPrivate,
                  activeColor: ColorsConsts.primaryColorLight,
                  onChanged: (value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                )
              ],
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: defaultPadding * 2, vertical: defaultPadding),
            width: MediaQuery.of(context).size.width,
            child: buildButtonCreatePlaylist(context),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildButtonCreatePlaylist(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_playlistNameController.text.isNotEmpty) {
          var uuid = const Uuid();
          PlaylistNew playlistNew = PlaylistNew(
            id: uuid.v4(),
            title: _playlistNameController.text,
            userName: FirebaseAuth.instance.currentUser!.displayName,
            userId: CommonUtils.userId,
            releaseDate: DateTime.now().toString(),
            isDownloading: _isDownloading,
            isPrivate: _isPrivate,
            tracks: [],
          );
          PlaylistNewService.instance.addItem(playlistNew);
          ToastCommon.showCustomText(
              content:
                  'Create playlist ${_playlistNameController.text} is success!');
          Navigator.pop(context);
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation1,
                  Animation<double> animation2) {
                return LayoutScreen(
                  index: 4,
                  screen: AddPlaylistDetailScreen(
                    playlistNew: playlistNew,
                  ),
                );
              },
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } else {
          setState(() {
            _errorText = 'Playlist Name is required';
          });
        }
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 1.5),
          shape: const StadiumBorder()),
      child: Text(
        'CREATE PLAYLIST',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
