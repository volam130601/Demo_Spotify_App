import 'package:demo_spotify_app/models/firebase/comment/comment_like.dart';
import 'package:demo_spotify_app/models/firebase/comment/comment_reply.dart';
import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../models/firebase/comment/comment.dart';
import '../../../repository/remote/firebase/comment_repository.dart';

class CommentLikeParentButton extends StatelessWidget {
  CommentLikeParentButton({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<CommentLike>? commentLikes = comment.commentLikes;
    if (commentLikes!.isNotEmpty) {
      CommentLike commentLike = commentLikes.firstWhere(
          (item) => item.userId == _user!.uid,
          orElse: () => CommentLike());
      if (commentLike.id != null) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                CommentRepository.instance.dislikeOfParentByUserId(
                    comment: comment, commentLike: commentLike);
              },
              child: const Icon(
                Ionicons.heart,
                color: Colors.redAccent,
                size: 16,
              ),
            ),
            paddingWidth(0.2),
            Text(
              '${commentLikes.length}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            )
          ],
        );
      }
      return Row(
        children: [
          InkWell(
            onTap: () {
              CommentRepository.instance.likeOfParentByUserId(comment);
            },
            child: const Icon(
              Ionicons.heart_outline,
              color: Colors.grey,
              size: 16,
            ),
          ),
          paddingWidth(0.2),
          Text(
            '${commentLikes.length}',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          )
        ],
      );
    }
    return InkWell(
      onTap: () {
        CommentRepository.instance.likeOfParentByUserId(comment);
      },
      child: const Icon(
        Ionicons.heart_outline,
        color: Colors.grey,
        size: 16,
      ),
    );
  }
}

class CommentLikeChildButton extends StatelessWidget {
  CommentLikeChildButton(
      {Key? key, required this.commentReply, required this.comment})
      : super(key: key);
  final Comment comment;
  final CommentReply commentReply;

  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<CommentLike>? commentLikes = commentReply.commentLikes;
    if (commentLikes!.isNotEmpty) {
      CommentLike commentLike = commentLikes.firstWhere(
          (item) => item.userId == _user!.uid,
          orElse: () => CommentLike());
      if (commentLike.id != null) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                CommentRepository.instance.dislikeOfChildByUserId(
                    commentReply: commentReply,
                    comment: comment,
                    commentLike: commentLike);
              },
              child: const Icon(
                Ionicons.heart,
                color: Colors.redAccent,
                size: 16,
              ),
            ),
            paddingWidth(0.2),
            Text(
              '${commentLikes.length}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
            )
          ],
        );
      }
      return Row(
        children: [
          InkWell(
            onTap: () {
              CommentRepository.instance.likeOfChildByUserId(
                  comment: comment, commentReply: commentReply);
            },
            child: const Icon(
              Ionicons.heart_outline,
              color: Colors.grey,
              size: 16,
            ),
          ),
          paddingWidth(0.2),
          Text(
            '${commentLikes.length}',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500),
          )
        ],
      );
    }
    return InkWell(
      onTap: () {
        CommentRepository.instance
            .likeOfChildByUserId(comment: comment, commentReply: commentReply);
      },
      child: const Icon(
        Ionicons.heart_outline,
        color: Colors.grey,
        size: 16,
      ),
    );
  }
}
