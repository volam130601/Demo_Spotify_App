import 'package:demo_spotify_app/res/constants/default_constant.dart';
import 'package:flutter/material.dart';

class ButtonCommon extends StatelessWidget {
  const ButtonCommon({
    super.key,
    required this.onPressed,
    required this.title,
    this.bgColor,
    this.isFitWidth = false,
  });

  final String title;
  final Color? bgColor;
  final bool isFitWidth;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFitWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            padding: const EdgeInsets.symmetric(vertical: defaultPadding * 2),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(defaultBorderRadius * 2.5))),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
