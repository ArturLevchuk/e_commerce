import 'package:flutter/material.dart';

PageRouteBuilder customFadePageRouteBuilder(
    {required Widget moveTo, dynamic arguments}) {
  return PageRouteBuilder(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // animation =
      //     CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
      // return ScaleTransition(
      //   scale: animation,
      //   alignment: Alignment.center,
      //   child: child,
      // );
      return FadeTransition(opacity: animation, child: child);
      // return SlideTransition(
      //   position: Tween<Offset>(
      //     begin: const Offset(-1.0, 0.0),
      //     end: Offset.zero,
      //   ).animate(animation),
      //   child: child,
      // );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return moveTo;
    },
    settings: RouteSettings(arguments: arguments),
  );
}

PageRouteBuilder customSlidePageRouteBuilder(
    {required Widget moveTo, dynamic arguments}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return moveTo;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const Offset begin = Offset(0.0, 1.0);
      const Offset end = Offset.zero;
      return SlideTransition(
        position: Tween<Offset>(begin: begin, end: end).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      );
    },
    settings: RouteSettings(arguments: arguments),
  );
}