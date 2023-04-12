import 'package:demo_spotify_app/view_models/provider/dark_theme_provider.dart';
import 'package:demo_spotify_app/res/colors.dart';
import 'package:demo_spotify_app/res/components/button_common.dart';
import 'package:demo_spotify_app/res/constants/default_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/onboarding_first_image.jpg'),
                  fit: BoxFit.cover)),
          child: Stack(
            children: [
              Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child:
                      SvgPicture.asset('assets/images/logo_spotify_label.svg')),
              Container(color: Colors.black38),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding * 1.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enjoy Listening To Music',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: defaultPadding),
                      Text(
                        'Unleash your inner music lover with our ultimate music destination app. Access millions of songs and create the perfect playlist, all in one place.',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: defaultPadding * 2),
                      ButtonCommon(
                        title: 'Getting Started',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const SecondScreen()));
                        },
                        isFitWidth: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/onboarding_second_image.jpg'),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Positioned(
                top: 60,
                left: 0,
                right: 0,
                child:
                    SvgPicture.asset('assets/images/logo_spotify_label.svg')),
            Container(color: Colors.black38),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding * 1.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose Mode',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: defaultPadding * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  themeChange.darkTheme = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(defaultPadding),
                                shape: const CircleBorder(),
                                backgroundColor: themeChange.darkTheme
                                    ? ColorsConsts.primaryColorDark
                                    : ColorsConsts.gradientGrey,
                              ),
                              child: const Icon(
                                Ionicons.moon_outline,
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                            Text(
                              'Dark Mode',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  themeChange.darkTheme = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(defaultPadding),
                                shape: const CircleBorder(),
                                backgroundColor: themeChange.darkTheme
                                    ? ColorsConsts.gradientGrey
                                    : ColorsConsts.primaryColorDark,
                              ),
                              child: const Icon(
                                Ionicons.sunny_outline,
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: defaultPadding),
                            Text(
                              'Light Mode',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 3),
                    ButtonCommon(
                      title: 'Continue',
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      isFitWidth: true,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
