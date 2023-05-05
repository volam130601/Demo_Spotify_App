import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:flutter/material.dart';

import '../../widgets/navigator/slide_animation_page_route.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF01CB33),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF01CB33), Color(0xFF1C1B1B)],
                  stops: [0, 0.9],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(40)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'L',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                      paddingWidth(1),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Võ Lâm',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: '',
                                  children: [
                                    TextSpan(
                                        text: '0 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    TextSpan(
                                        text: 'followers',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: ' • 7 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                                    TextSpan(
                                        text: 'following',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  paddingHeight(1),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              SlideRightPageRoute(page: const EditProfile()));
                        },
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Edit',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      paddingWidth(1),
                      const Icon(
                        Icons.more_vert,
                        size: 30,
                      ),
                    ],
                  ),
                  paddingHeight(2),
                ],
              ),
            ),
            Text(
              'No recent activity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            paddingHeight(100),
          ],
        ),
      ),
    );
  }
}
