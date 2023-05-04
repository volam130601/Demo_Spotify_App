import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/network/firebase/comment_service.dart';
import 'package:demo_spotify_app/utils/colors.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../utils/constants/default_constant.dart';
import '../../../models/firebase/comment/comment.dart';
import '../../../models/firebase/comment/comment_reply.dart';
import '../../../view_models/comment_view_model.dart';
import 'comment_action.dart';
import 'comment_like_button.dart';
//TODO: continue modal comment , delete comment, edit comment
//TODO: Show paging , lazy loading, hide reply
class CommentBoxScreen extends StatelessWidget {
  const CommentBoxScreen({Key? key, required this.trackId}) : super(key: key);
  final String trackId;

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentViewModel>(
      builder: (context, value, child) => StreamBuilder(
        stream: CommentService.instance.getCommentsByTrackId(trackId),
        builder: (context, snapshot) {
          final height = MediaQuery.of(context).size.height - kToolbarHeight;
          final width = MediaQuery.of(context).size.width;
          Widget body;
          if (!snapshot.hasData) {
            body = Scaffold(
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          }
          List<Comment>? comments = snapshot.data;

          if (comments!.isEmpty) {
            body = buildNullComment(context, height, width);
          } else {
            int temp =
                comments.fold<int>(0, (acc, item) => acc + item.total!.toInt());
            value.setTotalComment(temp);
            body = buildCommentContent(context, height, width, comments, value);
          }
          return GestureDetector(
            onTap: () {
              value.clearInput(false);
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () async {
                    value.clearInput(true);
                    await Future.delayed(const Duration(milliseconds: 300));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(
                  '${CommonUtils.convertToShorthand(value.totalComment)} comment',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              body: SizedBox(
                width: width,
                child: Stack(
                  children: [
                    body,
                    buildInputComment(context, value),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCommentContent(BuildContext context, double height, double width,
      List<Comment> comments, CommentViewModel value) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: height,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              Comment comment = comments[index];
              List<CommentReply>? commentReplies = comment.commentReplies;
              return Padding(
                padding: EdgeInsets.only(
                    bottom:
                        (index == comments.length - 1) ? defaultPadding * 8 : 0,
                    top: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCommentParent(comment, context, value),
                    paddingHeight(1),
                    // ignore: prefer_is_empty
                    if (commentReplies!.length > 0) ...{
                      ...Iterable<int>.generate(commentReplies.length)
                          .map((index) {
                        CommentReply commentReply = commentReplies[index];
                        return buildCommentReply(
                            comment, commentReply, context, value);
                      })
                    }
                  ],
                ),
              );
            },
            itemCount: comments.length),
      ),
    );
  }

  Padding buildCommentParent(
      Comment comment, BuildContext context, CommentViewModel value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              radius: 50,
              foregroundImage:
                  CachedNetworkImageProvider(comment.user!.photoURL.toString()),
              backgroundImage:
                  const AssetImage("assets/images/music_default.jpg"),
            ),
          ),
          paddingWidth(0.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${comment.user!.name} • ${timeago.format(DateTime.parse(comment.createTime.toString()))}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 13, color: Colors.grey),
                ),
                paddingHeight(0.3),
                Text(
                  comment.content.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                  softWrap: true,
                ),
                paddingHeight(0.5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommentLikeParentButton(comment: comment),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                      child: Text(
                        '|',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        value.setCommentReply(comment);
                        await Future.delayed(const Duration(milliseconds: 100));
                        // ignore: use_build_context_synchronously
                        FocusScope.of(context).requestFocus(value.focusNode);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        color: Colors.transparent,
                        child: Text(
                          'Reply',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CommentAction(
            comment: comment,
          ),
        ],
      ),
    );
  }

  Padding buildCommentReply(Comment comment, CommentReply commentReply,
      BuildContext context, CommentViewModel value) {
    return Padding(
      padding: const EdgeInsets.only(
          left: defaultPadding + 48,
          right: defaultPadding,
          bottom: defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              radius: 50,
              foregroundImage: CachedNetworkImageProvider(
                  commentReply.user!.photoURL.toString()),
              backgroundImage:
                  const AssetImage("assets/images/music_default.jpg"),
            ),
          ),
          paddingWidth(0.5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${commentReply.user!.name} • ${timeago.format(DateTime.parse(commentReply.createTime.toString()))}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontSize: 13, color: Colors.grey),
                ),
                paddingHeight(0.3),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: '${commentReply.user!.name} ',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: commentReply.content,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                paddingHeight(0.5),
                Row(
                  children: [
                    CommentLikeChildButton(
                        comment: comment, commentReply: commentReply),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                      child: Text(
                        '|',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        value.setCommentReplyOfChild(comment, commentReply);
                        await Future.delayed(const Duration(milliseconds: 100));
                        // ignore: use_build_context_synchronously
                        FocusScope.of(context).requestFocus(value.focusNode);
                      },
                      child: Text(
                        'Reply',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.grey),
                      ),
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
    );
  }

  Widget buildNullComment(BuildContext context, double height, double width) {
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
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
            textAlign: TextAlign.center,
          )
        ]),
      ),
    );
  }

  Positioned buildInputComment(BuildContext context, CommentViewModel value) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: ColorsConsts.scaffoldColorDark,
        child: Column(
          children: [
            if (value.isReply) ...{
              SizedBox(
                height: 30,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    children: [
                      Text(
                        'Answer',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.grey),
                      ),
                      paddingWidth(1),
                      Text(
                        value.comment.user!.name.toString(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            },
            if (value.isReplyOfChild) ...{
              SizedBox(
                height: 30,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    children: [
                      Text(
                        'Answer',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.grey),
                      ),
                      paddingWidth(1),
                      Text(
                        value.commentReply.user!.name.toString(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            },
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  if (value.isShowAvatar) ...{
                    Container(
                      margin: const EdgeInsets.only(left: defaultPadding),
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: CachedNetworkImageProvider(FirebaseAuth
                            .instance.currentUser!.photoURL
                            .toString()),
                      ),
                    )
                  },
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 40,
                          padding: const EdgeInsets.only(
                              left: defaultPadding, right: 50),
                          margin: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade500)),
                          child: TextField(
                            focusNode: value.focusNode,
                            decoration: InputDecoration(
                                hintText: "Enter comment...",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.grey),
                                border: InputBorder.none),
                            textInputAction: TextInputAction.done,
                            controller: value.commentController,
                            maxLines: 1,
                            onSubmitted: (newValue) =>
                                value.onPressEnterInput(trackId),
                            onTap: () => value.setShowAvatar(false),
                          ),
                        ),
                        if (!value.isShowAvatar) ...{
                          Positioned(
                            right: 5,
                            child: GestureDetector(
                              onTap: () => value.onPressEnterInput(trackId),
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
                            ),
                          ),
                        }
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
