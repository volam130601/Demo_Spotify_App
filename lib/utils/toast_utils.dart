import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'constants/default_constant.dart';

class ToastCommon {
  static void showCustomText({required String content}) {
    BotToast.showCustomText(
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 400),
      animationReverseDuration: const Duration(milliseconds: 400),
      toastBuilder: (_) => Align(
        alignment: const Alignment(0, 0.8),
        child: Card(
          color: const Color.fromRGBO(125, 125, 125, 0.7),
          shape: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/spotify_logo.svg',
                  width: 20,
                  height: 20,
                ),
                paddingWidth(0.5),
                Text(content),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
