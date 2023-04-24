import 'package:flutter/material.dart';

import '../../../utils/constants/default_constant.dart';

class ContainerNullValue extends StatelessWidget {
  const ContainerNullValue(
      {Key? key,
        required this.image,
        required this.title,
        required this.subtitle})
      : super(key: key);
  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        paddingHeight(2),
        Image.asset(
          image,
          color: Colors.white,
        ),
        paddingHeight(1.5),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        paddingHeight(0.5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 4),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
