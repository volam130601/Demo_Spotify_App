import 'package:demo_spotify_app/utils/constants/default_constant.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../models/firebase/comment/comment.dart';

class CommentAction extends StatelessWidget {
  const CommentAction({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.grey.shade900,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bình luận của Võ Lâm',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
                    child: Divider(),
                  ),
                  buildListTileItem(
                    context,
                    title: 'Reply',
                    icon: const Icon(Ionicons.chatbox_outline),
                    onTap: () {},
                  ),
                  buildListTileItem(
                    context,
                    title: 'Copy',
                    icon: const Icon(Ionicons.copy_outline),
                    onTap: () {},
                  ),
                  buildListTileItem(
                    context,
                    title: 'Remove',
                    icon: const Icon(Ionicons.trash_outline),
                    onTap: () {},
                  ),
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
