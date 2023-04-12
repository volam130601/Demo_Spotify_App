import 'package:demo_spotify_app/res/constants/default_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

PreferredSize loginAppbar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: Container(
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          SizedBox(
            width: 80,
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
          ),
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/images/logo_spotify_label.svg',
                width: 130,
              ),
            ),
          ),
          const SizedBox(width: 80)
        ],
      ),
    ),
  );
}
