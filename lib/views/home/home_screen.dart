import 'package:demo_spotify_app/views/home/tab_home.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../data/response/status.dart';
import '../../res/constants/default_constant.dart';
import '../../view_models/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setIsLoading();

    Provider.of<HomeViewModel>(context, listen: false)
      ..fetchChartPlaylistsApi()
      ..fetchChartAlbumsApi()
      ..fetchChartTracksApi()
      ..fetchChartArtistsApi();
  }
  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {
      isLoading = false;
    });
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
      body: Consumer<HomeViewModel>(
        builder:(context , value , child) {
          switch (value.chartPlaylists.status) {
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
              return Container(
                padding: const EdgeInsets.only(top: defaultPadding),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      paddingHeight(2),
                      const PlaylistView(),
                      paddingHeight(2),
                      const AlbumLists(),
                      paddingHeight(2),
                      const TrackListView(),
                      paddingHeight(2),
                      const ArtistList(),
                      paddingHeight(8),
                    ],
                  ),
                ),
              );
            case Status.ERROR:
              return Text(value.chartPlaylists.toString());
            default:
              return const Text('Default Switch');
          }
        },
      ),
    );
    }
  }
}
