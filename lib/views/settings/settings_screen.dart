import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/network/firebase/auth_google_service.dart';
import '../../utils/routes/route_name.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _auth = FirebaseAuth.instance;
  bool isCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_auth.currentUser != null) {
      setState(() {
        isCheck = true;
      });
    } else {
      setState(() {
        isCheck = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
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
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider((isCheck && user!.photoURL != null)
                    ? '${user.photoURL}'
                    : 'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg'),
              ),
              title: Text(
                (isCheck) ? '${user!.displayName}' : 'Your name',
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
                if(isCheck) {
                  _auth.signOut();
                  AuthGoogle().signOut();
                  Navigator.of(context).pushNamed(RoutesName.login);
                  setState(() {
                    isCheck = false;
                  });
                } else {
                  Navigator.of(context).pushNamed(RoutesName.login);
                }
              },
              title: (isCheck) ? 'Log out' : 'Log in',
              subTitle:(isCheck) ?  'You are logged in as Lam Vo' : 'You want to sign in spotify app.'),
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
