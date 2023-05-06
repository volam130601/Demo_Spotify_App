import 'package:flutter/material.dart';
class SettingItem extends StatelessWidget {
  const SettingItem(
      {Key? key, this.onTap, required this.title, required this.subTitle})
      : super(key: key);
  final VoidCallback? onTap;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          subTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey.shade700, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}


