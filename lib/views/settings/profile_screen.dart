import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/navigator/slide_animation_page_route.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2EC528),
      ),
      body: Consumer<SignInViewModel>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2EC528), Color(0xFF1C1B1B)],
                      stops: [0, 0.9],
                      begin: AlignmentDirectional(0, -1),
                      end: AlignmentDirectional(0, 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          (value.user.photoUrl != null)
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage: CachedNetworkImageProvider(
                                      '${value.user.photoUrl}'))
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundColor: Colors.red,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      value.user.displayName!
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                              fontSize: 80,
                                              color: Colors.black),
                                    ),
                                  ),
                                ),
                          paddingWidth(1),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.user.displayName.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
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
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                              Navigator.of(context).push(SlideRightPageRoute(
                                  page: const EditProfile()));
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
          );
        },
      ),
    );
  }
}
