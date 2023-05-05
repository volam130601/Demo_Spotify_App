import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:demo_spotify_app/views/settings/profile_screen.dart';
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
    final signInProvider = Provider.of<SignInViewModel>(context, listen: false);
    bool isCheckUser = signInProvider.user.id != null;
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
          InkWell(
            onTap: () {},
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(SlideRightPageRoute(page: const ProfileScreen()));
              },
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider((isCheckUser)
                    ? '${signInProvider.user.photoUrl}'
                    : 'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg'),
              ),
              title: Text(
                (isCheckUser)
                    ? '${signInProvider.user.displayName}'
                    : 'Your name',
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
          ),
          const SettingItem(title: 'Version', subTitle: '1.0.0-beta'),
          SettingItem(
              onTap: () {
                if (isCheckUser) {
                  FirebaseAuth.instance.signOut();
                  AuthGoogle().signOut();
                  signInProvider.signOut();
                  Provider.of<LayoutScreenViewModel>(context, listen: false).setPageIndex(0);
                  Navigator.of(context).pushNamed(RoutesName.login);
                  ToastCommon.showCustomText(content: 'Log out is success.');
                } else {
                  Navigator.of(context).pushNamed(RoutesName.login);
                }
              },
              title: (isCheckUser) ? 'Log out' : 'Log in',
              subTitle: (isCheckUser)
                  ? 'You are logged in as Lam Vo'
                  : 'You want to sign in spotify app.'),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem(
      {Key? key, this.onTap, required this.title, required this.subTitle})
      : super(key: key);
  final VoidCallback? onTap;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
