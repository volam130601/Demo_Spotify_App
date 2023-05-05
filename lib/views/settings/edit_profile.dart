import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Initial value';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              paddingHeight(3),
              SizedBox(
                height: MediaQuery.of(context).size.width * .5,
                width: MediaQuery.of(context).size.width * .5,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.red,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'L',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 80, color: Colors.black),
                    ),
                  ),
                ),
              ),
              paddingHeight(0.5),
              Text(
                'Change photo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              paddingHeight(2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
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

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding * 2, vertical: defaultPadding),
                child: Text(
                  'This could be your first name or a nickname. It\'s how you\'ll appear on Spotify.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Ionicons.close),
      ),
      title: Text(
        'Edit profile',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {},
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
