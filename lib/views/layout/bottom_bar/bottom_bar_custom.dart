import 'package:demo_spotify_app/view_models/layout_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../layout_screen.dart';
import 'bottom_bar_item.dart';

class BottomNavigatorBarCustom extends StatelessWidget {
  const BottomNavigatorBarCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainScreenProvider = Provider.of<LayoutScreenViewModel>(context);
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.8),
                  Color.fromRGBO(0, 0, 0, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavigatorItemChild(
                index: 0,
                iconSelected: const Icon(IconlyBold.home),
                iconUnSelected: const Icon(IconlyLight.home),
                label: 'Home',
                onTap: () {
                  mainScreenProvider.setPageIndex(0);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 0, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              BottomNavigatorItemChild(
                index: 1,
                iconSelected: const Icon(IconlyBold.search),
                iconUnSelected: const Icon(IconlyLight.search),
                label: 'Search',
                onTap: () {
                  mainScreenProvider.setPageIndex(1);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 1, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              BottomNavigatorItemChild(
                index: 2,
                iconSelected: const Icon(IconlyBold.folder),
                iconUnSelected: const Icon(IconlyLight.folder),
                label: 'Library',
                onTap: () {
                  mainScreenProvider.setPageIndex(2);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 2, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              BottomNavigatorItemChild(
                index: 3,
                iconSelected: const Icon(Ionicons.settings_sharp),
                iconUnSelected: const Icon(Ionicons.settings_outline),
                label: 'Settings',
                onTap: () {
                  mainScreenProvider.setPageIndex(3);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation1,
                          Animation<double> animation2) {
                        return const LayoutScreen(
                            index: 3, screen: Placeholder());
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
