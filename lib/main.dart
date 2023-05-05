import 'package:bot_toast/bot_toast.dart';
import 'package:demo_spotify_app/utils/theme_data.dart';
import 'package:demo_spotify_app/view_models/album_view_model.dart';
import 'package:demo_spotify_app/view_models/artist_view_model.dart';
import 'package:demo_spotify_app/view_models/comment_view_model.dart';
import 'package:demo_spotify_app/view_models/download_view_modal.dart';
import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/library/follow_artist_view_model.dart';
import 'package:demo_spotify_app/view_models/library/library_view_model.dart';
import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:demo_spotify_app/view_models/playlist_view_model.dart';
import 'package:demo_spotify_app/view_models/search_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:demo_spotify_app/views/login/main_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:nested/nested.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setIsLoading();
  }

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: isLoading
          ? Center(
              child: SvgPicture.asset('assets/images/logo_spotify_label.svg'))
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Demo Spotify App',
              theme: Styles.themeData(true, context),
              initialRoute: (FirebaseAuth.instance.currentUser != null)
                  ? RoutesName.home
                  : RoutesName.login,
              routes: {
                RoutesName.home: (context) =>
                    const LayoutScreen(index: 0, screen: Placeholder()),
                RoutesName.login: (context) => const LoginScreen(),
              },
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
            ),
    );
  }
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => SignInViewModel()),
  ChangeNotifierProvider(create: (_) => HomeViewModel()),
  ChangeNotifierProvider(create: (_) => TrackPlayViewModel()),
  ChangeNotifierProvider(create: (_) => AlbumViewModel()),
  ChangeNotifierProvider(create: (_) => PlaylistViewModel()),
  ChangeNotifierProvider(create: (_) => ArtistViewModel()),
  ChangeNotifierProvider(create: (_) => MultiPlayerViewModel()),
  ChangeNotifierProvider(create: (_) => SearchViewModel()),
  ChangeNotifierProvider(create: (_) => LayoutScreenViewModel()),
  ChangeNotifierProvider(create: (_) => DownloadViewModel()),
  ChangeNotifierProvider(create: (_) => LibraryViewModel()),
  ChangeNotifierProvider(create: (_) => FollowArtistViewModel()),
  ChangeNotifierProvider(create: (_) => CommentViewModel()),
];
