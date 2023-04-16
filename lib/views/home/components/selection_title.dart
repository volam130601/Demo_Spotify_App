import 'package:flutter/material.dart';

import '../../../utils/constants/default_constant.dart';

class SelectionTitle extends StatelessWidget {
  const SelectionTitle(
      {Key? key, required this.title, this.centerTitle = false})
      : super(key: key);
  final String title;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          Expanded(
            child:  Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          paddingWidth(1)
        ],
      ),
    );
  }
}
