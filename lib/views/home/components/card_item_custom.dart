import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/default_constant.dart';

class CardItemCustom extends StatefulWidget {
  const CardItemCustom({
    Key? key,
    required this.image,
    this.titleTop,
    this.titleBottom,
    this.centerTitle = false,
    this.isCircle = false,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String? titleTop;
  final String? titleBottom;
  final bool? centerTitle;
  final bool? isCircle;
  final VoidCallback? onTap;

  @override
  State<CardItemCustom> createState() => _CardItemCustomState();
}

class _CardItemCustomState extends State<CardItemCustom> {
  @override
  Widget build(BuildContext context) {
    Widget? cardImage;
    if(widget.isCircle == true) {
      cardImage = SizedBox(
        width: double.infinity,
        height: 150,
        child: CircleAvatar(
          radius: 50,
          foregroundImage: CachedNetworkImageProvider(widget.image),
          backgroundImage: const AssetImage("assets/images/music_default.jpg") ,
        ),
      );
    } else {
      cardImage =  SizedBox(
        width: double.infinity,
        height: 150,
        child: CachedNetworkImage(
          imageUrl: widget.image,
          placeholder: (context, url) => Image.asset('assets/images/music_default.jpg', fit: BoxFit.cover,),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      );
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(left: defaultPadding),
        child: Column(
          crossAxisAlignment: (widget.centerTitle == true)
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            cardImage,
            paddingHeight(0.3),
            _cardName(widget.titleTop, widget.titleBottom)
          ],
        ),
      ),
    );
  }

  Widget _cardName(String? titleTop, String? titleBottom) {
    return Column(
      crossAxisAlignment: (widget.centerTitle == true)
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        titleTop != null
            ? Text(
                titleTop.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : const SizedBox(),
        paddingHeight(0.2),
        titleBottom != null
            ? Text(
                titleBottom.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : const SizedBox(),
      ],
    );
  }
}
