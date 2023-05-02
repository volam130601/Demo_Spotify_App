import 'package:flutter/material.dart';

import '../../views/layout_screen.dart';

class DefaultPageRoute extends PageRouteBuilder {
  final Widget page;

  DefaultPageRoute({required this.page})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation1,
              Animation<double> animation2) {
            return page;
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
}

class NavigatorPage {
  static void defaultPageRoute(BuildContext context, Widget page) {
    Navigator.of(context).push(
      DefaultPageRoute(
        page: page,
      ),
    );
  }

  static void defaultLayoutPageRoute(BuildContext context, Widget page) {
    Navigator.of(context).push(
      DefaultPageRoute(
        page: LayoutScreen(
          index: 4,
          screen: page,
        ),
      ),
    );
  }
}
