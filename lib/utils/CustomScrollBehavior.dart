import 'package:flutter/material.dart';

class CustomScrollBehavior extends ScrollBehavior {
  // @override
  // Widget buildViewportChrome(
  //     BuildContext context, Widget child, AxisDirection axisDirection) {
  //   // Disable the glow effect
  //   return child;
  // }

    @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}