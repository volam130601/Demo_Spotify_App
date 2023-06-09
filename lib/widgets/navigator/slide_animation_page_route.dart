import 'package:flutter/material.dart';

class SlideTopPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideTopPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          },
        );
}

class SlideRightPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightPageRoute({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
  );
}


class SlideLeftPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftPageRoute({required this.page})
      : super(
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
  );
}


