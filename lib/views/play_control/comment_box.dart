import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_spotify_app/data/network/firebase/comment_service.dart';
import 'package:demo_spotify_app/utils/colors.dart';
import 'package:demo_spotify_app/utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../utils/constants/default_constant.dart';
import '../../models/firebase/comment.dart';

//TODO: Show paging , lazy loading, hide reply
class CommentBoxScreen extends StatefulWidget {
  const CommentBoxScreen({Key? key, required this.trackId}) : super(key: key);
  final String trackId;

  @override
  State<CommentBoxScreen> createState() => _CommentBoxScreenState();
}

class _CommentBoxScreenState extends State<CommentBoxScreen> {
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isShowAvatar = true;
  bool _isReply = false;
  bool _isReplyOfChild = false;
  Comment _comment = Comment();
  CommentReply _commentReply = CommentReply();
  int totalComment = 0;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _commentController.dispose();
  }

  void setShowAvatar(newValue) {
    setState(() {
      _isShowAvatar = newValue;
    });
  }

  void clearInput(bool isClear) {
    setShowAvatar(true);
    _focusNode.unfocus();
    if (isClear) {
      _commentController.clear();
      setState(() {
        _isReply = false;
        _isReplyOfChild = false;
      });
    }
  }

  void setCommentReply(Comment comment) {
    setState(() {
      _isReply = true;
      _comment = comment;
    });
  }

  void setCommentReplyOfChild(Comment comment, CommentReply commentReply) {
    setState(() {
      _isReplyOfChild = true;
      _comment = comment;
      _commentReply = commentReply;
    });
  }

  void pushComment() {
    CommentService.instance.addCommentOfTrack(
        content: _commentController.text, trackId: widget.trackId);
  }

  void pushCommentReply() {
    CommentService.instance.addCommentReplyOfParentComment(
      content: _commentController.text,
      comment: _comment,
    );
  }

  void pushCommentReplyOfChild() {
    CommentService.instance.addCommentReplyOfChildComment(
        content: _commentController.text,
        comment: _comment,
        commentReply: _commentReply);
  }

  void onPressEnterInput() {
    if (_isReply) {
      pushCommentReply();
    } else if (_isReplyOfChild) {
      pushCommentReplyOfChild();
    } else {
      pushComment();
    }
    clearInput(true);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - kToolbarHeight;
    final width = MediaQuery.of(context).size.width;
    Widget body;
    body = StreamBuilder(
      stream: CommentService.instance.getCommentsByTrackId(widget.trackId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
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
          return buildNullComment(context, height, width);
        } else {
          int temp = 0;
          for (var item in comments) {
            temp += item.total!.toInt();
          }
          totalComment = temp;
          return buildCommentContent(context, height, width, comments);
        }
      },
    );
    return GestureDetector(
      onTap: () {
        clearInput(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              clearInput(true);
              await Future.delayed(const Duration(milliseconds: 300));
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            '${CommonUtils.convertToShorthand(totalComment)} comment',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        body: SizedBox(
          width: width,
          child: Stack(
            children: [
              body,
              buildInputComment(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCommentContent(BuildContext context, double height, double width,
      List<Comment> comments) {
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
                    buildCommentParent(comment, context),
                    paddingHeight(1),
                    // ignore: prefer_is_empty
                    if (commentReplies!.length > 0) ...{
                      ...Iterable<int>.generate(commentReplies.length)
                          .map((index) {
                        CommentReply commentReply = commentReplies[index];
                        return buildCommentReply(
                            comment, commentReply, context);
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

  Padding buildCommentParent(Comment comment, BuildContext context) {
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
                    InkWell(
                      onTap: () async {
                        setCommentReply(comment);
                        await Future.delayed(const Duration(milliseconds: 100));
                        setState(() {
                          FocusScope.of(context).requestFocus(_focusNode);
                        });
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

  Padding buildCommentReply(
      Comment comment, CommentReply commentReply, BuildContext context) {
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
                    const Icon(
                      Ionicons.heart_outline,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const Text(
                      ' | ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setCommentReplyOfChild(comment, commentReply);
                        await Future.delayed(const Duration(milliseconds: 100));
                        setState(() {
                          FocusScope.of(context).requestFocus(_focusNode);
                        });
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

  Positioned buildInputComment(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: ColorsConsts.scaffoldColorDark,
        child: Column(
          children: [
            if (_isReply) ...{
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
                        _comment.user!.name.toString(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            },
            if (_isReplyOfChild) ...{
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
                        _commentReply.user!.name.toString(),
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
                  if (_isShowAvatar) ...{
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
                            onSubmitted: (value) => onPressEnterInput(),
                            onTap: () => setShowAvatar(false),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          child: GestureDetector(
                            onTap: () => onPressEnterInput(),
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
