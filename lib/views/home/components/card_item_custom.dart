import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../res/constants/default_constant.dart';

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
            Stack(children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  shape: widget.isCircle == true
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ]),
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
