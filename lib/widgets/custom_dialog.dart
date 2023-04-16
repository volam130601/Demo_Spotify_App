import 'package:demo_spotify_app/views/login/sign_in_screen.dart';
import 'package:demo_spotify_app/widgets/slide_animation_page_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/colors.dart';
import '../utils/constants/default_constant.dart';


class CustomDiaLog extends StatelessWidget {
  const CustomDiaLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defaultBorderRadius)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorsConsts.primaryColorDark,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(defaultBorderRadius),
                topRight: Radius.circular(defaultBorderRadius),
              ),
            ),
            child: const Icon(
              Ionicons.checkmark_circle_outline,
              size: 100,
              color: Colors.white,
            ),
          ),
          paddingHeight(1),
          Text(
            'Congratulations! Your sign up was successful.',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          paddingHeight(1),
          Text(
            'Do you want to log in now.',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          paddingHeight(2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: Text(
                  'Go to Login',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(SlideRightPageRoute(page: const SignInScreen()));
                },
              ),
              TextButton(
                style: TextButton.styleFrom(),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
          paddingHeight(1),
        ],
      ),
    );
  }
}
