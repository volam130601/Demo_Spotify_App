import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/default_constant.dart';

class SearchTileItem extends StatelessWidget {
  const SearchTileItem({
    Key? key,
    required this.image,
    required this.title,
    this.subTitle,
    this.onTap,
    this.isTrack = false,
    this.isArtist = false,
  }) : super(key: key);
  final String image;
  final String title;
  final String? subTitle;
  final VoidCallback? onTap;

  final bool? isTrack;
  final bool? isArtist;

  @override
  Widget build(BuildContext context) {
    if (isTrack == true) {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: defaultPadding / 2),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
              ),
              child: CachedNetworkImage(
                imageUrl: image,
                placeholder: (context, url) => Image.asset(
                  'assets/images/music_default.jpg',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              subTitle!,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ),
      );
    }
    if (isArtist == true) {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: defaultPadding / 1.5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(image),
              radius: 30,
              backgroundColor: Colors.black38,
            ),
            title: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                paddingWidth(0.2),
                const Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
