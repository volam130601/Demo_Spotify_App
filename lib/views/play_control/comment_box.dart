import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/default_constant.dart';
import '../../../view_models/layout_screen_view_model.dart';

class CommentBoxScreen extends StatefulWidget {
  const CommentBoxScreen({Key? key}) : super(key: key);

  @override
  State<CommentBoxScreen> createState() => _CommentBoxScreenState();
}

class _CommentBoxScreenState extends State<CommentBoxScreen> {
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  final Duration _searchDelay = const Duration(milliseconds: 500);
  bool isShowAvatar = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.unfocus();
    _commentController.clear();
  }

  void setShowAvatar(newValue) {
    setState(() {
      isShowAvatar = newValue;
    });
  }
  void clearInput() {
    setShowAvatar(true);
    _focusNode.unfocus();
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
        setShowAvatar(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              '1,1K comment',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          body: SizedBox(
            width: width,
            child: Stack(
              children: [
                buildCommentContent(context, height),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: ColorsConsts.scaffoldColorDark,
                    child: Row(
                      children: [
                        if (isShowAvatar) ...{
                          Container(
                            margin: const EdgeInsets.only(left: defaultPadding),
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundImage: CachedNetworkImageProvider(
                                  FirebaseAuth.instance.currentUser!.photoURL
                                      .toString()),
                            ),
                          )
                        },
                        Expanded(
                          child: Stack(children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade500)),
                              child: TextField(
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                    hintText: "Enter comment...",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: Colors.grey),
                                    border: InputBorder.none),
                                textInputAction: TextInputAction.done,
                                controller: _commentController,
                                maxLines: 1,
                                onSubmitted: (value) {
                                  print(value);
                                  clearInput();
                                },
                                onTap: () => setShowAvatar(false),
                              ),
                            ),
                            Positioned(
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    print(_commentController.text);
                                    clearInput();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Ionicons.chevron_forward,
                                      color: Colors.black,
                                    ),
                                  ),
                                ))
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Align buildNullComment(double height, BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: height,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Ionicons.chatbox_outline,
            size: 100,
            color: Colors.grey,
          ),
          paddingHeight(2),
          Text(
            'Share your thoughts in the comments section below',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          )
        ]),
      ),
    );
  }

  Widget buildCommentContent(BuildContext context, double height) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(
              top: defaultPadding, bottom: defaultPadding * 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              paddingHeight(1),
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding + 48, right: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              paddingHeight(1),
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding + 48, right: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              paddingHeight(1),
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding + 48, right: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              paddingHeight(1),
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding + 48, right: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              paddingHeight(1),
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding + 48, right: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
              paddingHeight(1),
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding + 48, right: defaultPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        radius: 50,
                        foregroundImage: CachedNetworkImageProvider(
                            'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/250x250-000000-80-0-0.jpg'),
                        backgroundImage:
                            AssetImage("assets/images/music_default.jpg"),
                      ),
                    ),
                    paddingWidth(0.5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lâm • 1 hours ago',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontSize: 13, color: Colors.grey),
                          ),
                          paddingHeight(0.5),
                          Text(
                            'hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi! hay qua bro oi!',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            softWrap: true,
                          ),
                          paddingHeight(0.5),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.heart_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const Text(
                                ' | ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Reply',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 30,
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
