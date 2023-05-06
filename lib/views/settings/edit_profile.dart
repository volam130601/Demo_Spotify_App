import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:demo_spotify_app/view_models/login/sign_in_view_model.dart';
import 'package:demo_spotify_app/view_models/setting/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _focusNode = FocusNode();
  final ProfileViewModel _profileViewModel = ProfileViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var value = Provider.of<SignInViewModel>(context, listen: false);
    if (value.user.displayName != null) {
      _nameController.text = value.user.displayName!;
      _profileViewModel.displayName = value.user.displayName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _profileViewModel,
      child: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Consumer2<SignInViewModel, ProfileViewModel>(
          builder: (context, signInValue, profileValue, child) {
            return Scaffold(
              appBar: buildAppBar(context,signInValue , profileValue),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    paddingHeight(3),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * .5,
                      width: MediaQuery.of(context).size.width * .5,
                      child: profileValue.imageFile != null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  FileImage(profileValue.imageFile!, scale: 1),
                            )
                          : (signInValue.user.photoUrl != null)
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundImage: CachedNetworkImageProvider(
                                      signInValue.user.photoUrl!))
                              : CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.red,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      signInValue.user.displayName!
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
                    ),
                    paddingHeight(0.5),
                    TextButton(
                      onPressed: () => profileValue.pickImage(),
                      child: Text(
                        'Change photo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    paddingHeight(2),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: TextField(
                        controller: _nameController,
                        focusNode: _focusNode,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.only(bottom: 0),
                        ),
                        style: Theme.of(context).textTheme.headlineSmall,
                        onSubmitted: (value) {
                          profileValue.setDisplayName(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                          vertical: defaultPadding),
                      child: Text(
                        'This could be your first name or a nickname. It\'s how you\'ll appear on Spotify.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, SignInViewModel signInValue, ProfileViewModel profileValue) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
          profileValue.clear();
        },
        icon: const Icon(Ionicons.close),
      ),
      title: Text(
        'Edit profile',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () async {
            _focusNode.unfocus();
            profileValue.setDisplayName(_nameController.text);
            await profileValue.editProfile(signInValue.user);
            signInValue.fetchLogin();
          },
          child: Text(
            'Save',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
