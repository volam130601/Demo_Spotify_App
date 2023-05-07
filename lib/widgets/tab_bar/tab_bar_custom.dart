import 'package:demo_spotify_app/utils/colors.dart';
import 'package:flutter/material.dart';

class StickyTabBarLibraryDelegate extends SliverPersistentHeaderDelegate {
  StickyTabBarLibraryDelegate({required this.child});

  final TabBar child;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: ColorsConsts.scaffoldColorDark,
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: child,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant StickyTabBarLibraryDelegate oldDelegate) {
    return false;
  }
}