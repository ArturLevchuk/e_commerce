import 'package:flutter/material.dart';

double getBodyHeight(BuildContext context) {
  final mediaQueryData = MediaQuery.of(context);
    double statusBarHeight = mediaQueryData.padding.top;
    double screenHeight = mediaQueryData.size.height;
    return screenHeight - statusBarHeight - kToolbarHeight;
}
