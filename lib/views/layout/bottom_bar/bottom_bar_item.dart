import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigatorItemChild extends StatelessWidget {
  const BottomNavigatorItemChild({
    Key? key,
    required this.index,
    required this.iconSelected,
    required this.iconUnSelected,
    required this.label,
    this.onTap,
  }) : super(key: key);
  final int index;
  final Widget iconSelected;
  final Widget iconUnSelected;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider = Provider.of<LayoutScreenViewModel>(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: 80,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (index == mainScreenProvider.pageIndex)
                    ? iconSelected
                    : iconUnSelected,
                const SizedBox(height: 2),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
