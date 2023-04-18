import 'package:demo_spotify_app/utils/theme_data.dart';
import 'package:demo_spotify_app/view_models/artist_view_model.dart';
import 'package:demo_spotify_app/view_models/home_view_model.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/view_models/search_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play_view_model.dart';
import 'package:demo_spotify_app/views/layout_screen.dart';
import 'package:demo_spotify_app/views/login/main_login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'utils/routes/route_name.dart';

Future<void> main() async {
  //Config notification play music
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setIsLoading();
  }

  bool isLoading = true;

  Future<void> setIsLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TrackPlayViewModel()),
        ChangeNotifierProvider(create: (_) => ArtistViewModel()),
        ChangeNotifierProvider(create: (_) => MultiPlayerViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => LayoutScreenViewModel()),
      ],
      child: isLoading
          ? Center(
              child: SvgPicture.asset('assets/images/logo_spotify_label.svg'))
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Demo Spotify App',
              theme: Styles.themeData(true, context),
              initialRoute: RoutesName.login,
              routes: {
                RoutesName.home: (context) =>
                    const LayoutScreen(index: 0, screen: Placeholder()),
                RoutesName.login: (context) => const LoginScreen(),
              },
            ),
    );
  }
}
