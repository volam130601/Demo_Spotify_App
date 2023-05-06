import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:demo_spotify_app/view_models/track_play/multi_control_player_view_model.dart';
import 'package:demo_spotify_app/views/settings/profile_screen.dart';
import 'package:demo_spotify_app/views/settings/setting_item.dart';
import 'package:demo_spotify_app/widgets/navigator/slide_animation_page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/network/firebase/auth_google_service.dart';
import '../../utils/routes/route_name.dart';
import '../../utils/toast_utils.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInViewModel>(
      builder: (context, value, child) {
        bool isCheckUser = value.user.id != null;
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            leadingWidth: 0,
            centerTitle: true,
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          body: Column(
            children: [
              buildUserListTileItem(context, isCheckUser, value),
              const SettingItem(title: 'Version', subTitle: '1.0.0-beta'),
              SettingItem(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RoutesName.login);
                    ToastCommon.showCustomText(content: 'Log out is success.');
                    FirebaseAuth.instance.signOut();
                    AuthGoogle().signOut();
                    value.signOut();
                    Provider.of<LayoutScreenViewModel>(context, listen: false)
                        .clear();
                    Provider.of<MultiPlayerViewModel>(context, listen: false)
                        .clear();
                  },
                  title: (isCheckUser) ? 'Log out' : 'Log in',
                  subTitle: (isCheckUser)
                      ? 'You are logged in as Lam Vo'
                      : 'You want to sign in spotify app.'),
            ],
          ),
        );
      },
    );
  }

  InkWell buildUserListTileItem(
      BuildContext context, bool isCheckUser, SignInViewModel signInProvider) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            SlideRightPageRoute(
              page: const ProfileScreen(),
            ),
          );
        },
        leading: (isCheckUser && signInProvider.user.photoUrl != null)
            ? CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider(
                    '${signInProvider.user.photoUrl}'))
            : CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    signInProvider.user.displayName!
                        .substring(0, 1)
                        .toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ),
        title: Text(
          (isCheckUser) ? '${signInProvider.user.displayName}' : 'Your name',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          'View profile',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
      ),
    );
  }
}
