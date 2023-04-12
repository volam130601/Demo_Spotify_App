import 'package:demo_spotify_app/res/colors.dart';
import 'package:demo_spotify_app/res/components/button_common.dart';
import 'package:demo_spotify_app/res/constants/default_constant.dart';
import 'package:demo_spotify_app/views/login/register_screen.dart';
import 'package:demo_spotify_app/views/login/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackButton(context),
          buildBackground(context),
          buildContent(context)
        ],
      ),
    );
  }

  Positioned buildBackButton(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF232222),
            padding: const EdgeInsets.all(defaultPadding / 1.5),
            shape: const CircleBorder()),
        child: const Icon(
          Ionicons.chevron_back_outline,
          size: 24,
        ),
      ),
    );
  }

  Positioned buildContent(BuildContext context) {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/logo_spotify_label.svg',
            width: 300,
          ),
          const SizedBox(height: defaultPadding * 3),
          Text(
            'Enjoy Listening To Music',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: defaultPadding * 1.5),
          Text(
            'Spotify is a proprietary Swedish audio streaming and media services provider',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: defaultPadding * 2),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: defaultPadding * 1.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ButtonCommon(
                    title: 'Register',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const RegisterScreen()));
                    },
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Expanded(
                  child: ButtonCommon(
                    title: 'Sign in',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const SignInScreen()));
                    },
                    bgColor: ColorsConsts.gradientGrey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBackground(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: -10,
          child: SvgPicture.asset('assets/images/login_wave_1.svg'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset('assets/images/login_wave_2.svg'),
        ),
        Positioned(
          bottom: 0,
          left: -50,
          child: Image.asset(
            'assets/images/login_person.png',
            width: 300,
          ),
        ),
      ],
    );
  }
}
