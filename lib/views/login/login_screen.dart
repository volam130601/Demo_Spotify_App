import 'package:demo_spotify_app/res/colors.dart';
import 'package:demo_spotify_app/views/home/home_screen.dart';
import 'package:demo_spotify_app/views/login/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

import '../../res/components/slide_animation_page_route.dart';
import '../../res/constants/default_constant.dart';
import '../../utils/routes/route_name.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/login/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromRGBO(0, 0, 0, 0.7),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 350,
                    child: SvgPicture.asset(
                      'assets/images/logo_spotify_label.svg',
                      width: 270,
                      // ignore: deprecated_member_use
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Millions of songs.',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Free on Spotify.',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white),
                  ),
                  paddingHeight(4),
                  buildButtonCommon(
                    context,
                    title: 'Sign up free',
                    onPressed: () {
                      Navigator.of(context)
                          .push(SlideRightPageRoute(page: const SignUpFree()));
                    },
                  ),
                  buildButtonCommon(
                    context,
                    title: 'Continue with phone number',
                    icon: const Icon(
                      Ionicons.phone_portrait_outline,
                      color: Colors.white,
                    ),
                    isOutline: true,
                    onPressed: () {
                      Navigator.of(context)
                          .push(SlideRightPageRoute(page: const SignUpFree()));
                    },
                  ),
                  buildButtonCommon(
                    context,
                    title: 'Continue with Google',
                    icon: SvgPicture.network(
                      'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                      width: 20,
                    ),
                    isOutline: true,
                    onPressed: () {
                      Navigator.of(context)
                          .push(SlideRightPageRoute(page: const SignUpFree()));
                    },
                  ),
                  buildButtonCommon(
                    context,
                    title: 'Continue with Facebook',
                    icon: SvgPicture.network(
                      'https://upload.wikimedia.org/wikipedia/commons/b/b8/2021_Facebook_icon.svg',
                      width: 20,
                    ),
                    isOutline: true,
                    onPressed: () {
                      Navigator.of(context)
                          .push(SlideRightPageRoute(page: const SignUpFree()));
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Log in',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildButtonCommon(BuildContext context,
      {String? title,
      Widget? icon,
      VoidCallback? onPressed,
      bool isOutline = false}) {
    if (isOutline == true) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
        margin: const EdgeInsets.only(bottom: defaultPadding / 2),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: const BorderSide(color: Colors.grey, width: 1),
            padding: const EdgeInsets.symmetric(
              vertical: defaultPadding,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              paddingWidth(1),
              icon!,
              Expanded(
                child: Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
      margin: const EdgeInsets.only(bottom: defaultPadding / 2),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: defaultPadding)),
        child: Text(
          title!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }
}