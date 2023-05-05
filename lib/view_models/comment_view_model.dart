import 'package:flutter/cupertino.dart';

import '../data/network/firebase/comment_service.dart';
import '../models/firebase/comment/comment.dart';
import '../models/firebase/comment/comment_reply.dart';

class CommentViewModel with ChangeNotifier {
  final TextEditingController commentController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool _isShowAvatar = true;
  bool _isReply = false;
  bool _isReplyOfChild = false;
  Comment _comment = Comment();
  CommentReply _commentReply = CommentReply();

  void clearInput(bool isClear) {
    _isShowAvatar = true;
    focusNode.unfocus();
    if (isClear) {
      commentController.clear();
    }
    if (commentController.text.isEmpty) {
      _isReply = false;
      _isReplyOfChild = false;
    }
    notifyListeners();
  }

  void setCommentReply(Comment comment) {
    _isReply = true;
    _comment = comment;
    _isShowAvatar = false;
    notifyListeners();
  }

  void setCommentReplyOfChild(Comment comment, CommentReply commentReply) {
    _comment = comment;
    _commentReply = commentReply;
    _isReplyOfChild = true;
    _isShowAvatar = false;
    notifyListeners();
  }

  void onPressEnterInput(String trackId) {
    if (_isReply) {
      pushCommentReply();
    } else if (_isReplyOfChild) {
      pushCommentReplyOfChild();
    } else {
      pushComment(trackId);
    }
    clearInput(true);
    notifyListeners();
  }

  void pushComment(String trackId) {
    CommentService.instance
        .addCommentOfTrack(content: commentController.text,
        trackId: trackId);
  }

  void pushCommentReply() {
    CommentService.instance.addCommentReplyOfParentComment(
      content: commentController.text,
      comment: _comment,
    );
  }

  void pushCommentReplyOfChild() {
    CommentService.instance.addCommentReplyOfChildComment(
        content: commentController.text,
        comment: _comment,
        commentReply: _commentReply);
  }

  bool get isReply => _isReply;

  bool get isReplyOfChild => _isReplyOfChild;

  Comment get comment => _comment;

  CommentReply get commentReply => _commentReply;

  bool get isShowAvatar => _isShowAvatar;

  void setShowAvatar(newValue) {
    _isShowAvatar = newValue;
    notifyListeners();
  }
}
