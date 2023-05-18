import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:demo_spotify_app/utils/theme_data.dart';
import 'package:demo_spotify_app/view_models/search/genre_detail_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play/comment_view_model.dart';
import 'package:demo_spotify_app/view_models/download_view_modal.dart';
import 'package:demo_spotify_app/view_models/home/album_view_model.dart';
import 'package:demo_spotify_app/view_models/home/artist_view_model.dart';
import 'package:demo_spotify_app/view_models/home/home_view_model.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/library/follow_artist_view_model.dart';
import 'package:demo_spotify_app/view_models/library/library_view_model.dart';
import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:demo_spotify_app/view_models/home/playlist_view_model.dart';
import 'package:demo_spotify_app/view_models/search/search_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play/track_play_view_model.dart';
import 'package:demo_spotify_app/views/layout/layout_screen.dart';
import 'package:demo_spotify_app/views/library/download_screen.dart';
import 'package:demo_spotify_app/views/login/main_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'utils/routes/route_name.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Connectivity connectivity = Connectivity();
  bool isLoading = true;
  bool isNoInternet = false;

  @override
  void initState() {
    super.initState();
    setIsLoading();
  }

  Future<void> setIsLoading() async {
    bool isCheck = false;
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection');
      isCheck = true;
    }
    print('check : $isCheck');
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
      isNoInternet = isCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TrackPlayViewModel()),
        ChangeNotifierProvider(create: (_) => AlbumViewModel()),
        ChangeNotifierProvider(create: (_) => PlaylistViewModel()),
        ChangeNotifierProvider(create: (_) => ArtistViewModel()),
        ChangeNotifierProvider(create: (_) => MultiPlayerViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => GenreDetailViewModel()),
        ChangeNotifierProvider(create: (_) => LayoutScreenViewModel()),
        ChangeNotifierProvider(create: (_) => DownloadViewModel()),
        ChangeNotifierProvider(create: (_) => LibraryViewModel()),
        ChangeNotifierProvider(create: (_) => FollowArtistViewModel()),
        ChangeNotifierProvider(create: (_) => CommentViewModel()),
      ],
      child: isLoading
          ? Center(
              child: SvgPicture.asset('assets/images/logo_spotify_label.svg'))
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Demo Spotify App',
              theme: Styles.themeData(true, context),
              initialRoute: isNoInternet
                  ? RoutesName.downloadedScreen
                  : FirebaseAuth.instance.currentUser != null
                      ? RoutesName.home
                      : RoutesName.login,
              routes: {
                RoutesName.home: (context) =>
                    const LayoutScreen(index: 0, screen: Placeholder()),
                RoutesName.login: (context) => const LoginScreen(),
                RoutesName.downloadedScreen: (context) => const DownloadScreen(),
              },
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
            ),
    );
  }
}
