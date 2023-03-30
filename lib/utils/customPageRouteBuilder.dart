import 'package:flutter/material.dart';

PageRouteBuilder customPageRouteBuilder(
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
