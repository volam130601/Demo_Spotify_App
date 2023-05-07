import 'package:demo_spotify_app/data/network/firebase/comment_service.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:demo_spotify_app/utils/toast_utils.dart';
import 'package:demo_spotify_app/view_models/comment_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../../models/firebase/comment/comment.dart';
import '../../../models/firebase/comment/comment_reply.dart';

class CommentAction extends StatelessWidget {
  const CommentAction(
      {Key? key,
      required this.comment,
      required this.contextParent,
      this.commentReply})
      : super(key: key);
  final Comment comment;
  final CommentReply? commentReply;
  final BuildContext contextParent;

  void buttonCommentReply(Comment comment, CommentViewModel value) async {
    value.setCommentReply(comment);
    await Future.delayed(const Duration(milliseconds: 100));
    // ignore: use_build_context_synchronously
    FocusScope.of(contextParent).requestFocus(value.focusNode);
  }

  void buttonCommentReplyOfChild(Comment comment, CommentReply commentReply,
      CommentViewModel value) async {
    value.setCommentReplyOfChild(comment, commentReply);
    await Future.delayed(const Duration(milliseconds: 100));
    // ignore: use_build_context_synchronously
    FocusScope.of(contextParent).requestFocus(value.focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentViewModel>(
      builder: (context, value, child) => InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.grey.shade900,
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            builder: (context) {
              final bool isUserComment =
                  comment.user!.id == FirebaseAuth.instance.currentUser!.uid;
              final bool isChildComment = commentReply != null &&
                  commentReply!.user!.id ==
                      FirebaseAuth.instance.currentUser!.uid;
              final itemRemove = isChildComment || isUserComment
                  ? buildListTileItem(
                      context,
                      title: 'Remove',
                      icon: const Icon(Ionicons.trash_outline),
                      onTap: () {
                        if (isChildComment) {
                          CommentService.instance
                              .deleteCommentChild(comment, commentReply!);
                        } else {
                          CommentService.instance.deleteCommentParent(comment);
                        }
                        Navigator.pop(context);
                        ToastCommon.showCustomText(
                            content: 'Remove comment is success');
                      },
                    )
                  : const SizedBox();
              return Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (commentReply != null)
                          ? 'Bình luận của ${commentReply!.user!.name}'
                          : 'Bình luận của ${comment.user!.name}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: defaultPadding / 2),
                      child: Divider(),
                    ),
                    buildListTileItem(
                      context,
                      title: 'Reply',
                      icon: const Icon(Ionicons.chatbox_outline),
                      onTap: () {
                        Navigator.pop(context);
                        if (commentReply != null) {
                          buttonCommentReplyOfChild(
                              comment, commentReply!, value);
                        } else {
                          buttonCommentReply(comment, value);
                        }
                      },
                    ),
                    buildListTileItem(
                      context,
                      title: 'Copy',
                      icon: const Icon(Ionicons.copy_outline),
                      onTap: () {
                        Navigator.pop(context);
                        if (commentReply != null) {
                          Clipboard.setData(
                              ClipboardData(text: commentReply!.content));
                        } else {
                          Clipboard.setData(
                              ClipboardData(text: comment.content));
                        }
                      },
                    ),
                    itemRemove,
                  ],
                ),
              );
            },
          );
        },
        child: const SizedBox(
          width: 20,
          height: 30,
          child: Icon(
            Icons.more_vert,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget buildListTileItem(BuildContext context,
      {required String title, required Icon icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        color: Colors.transparent,
        child: Row(
          children: [
            icon,
            paddingWidth(1),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ),
    );
  }
}
