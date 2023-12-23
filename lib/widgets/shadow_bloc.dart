import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';

class ShadowBloc extends StatelessWidget {
  const ShadowBloc({
    super.key,
    required this.widget,
    this.defPadding = 10,
  });
  final Widget widget;
  final double defPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      // duration: kAnimationDuration,
      // curve: Curves.easeInOut,
      margin: const EdgeInsets.only(
        top: 20,
      ).r,
      padding: EdgeInsets.all(defPadding).r,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          themedBoxShadow(Theme.of(context).brightness),
        ],
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: AnimatedSize(
        alignment: Alignment.topCenter,
        duration: kAnimationDuration,
        child: widget,
      ),
    );
  }
}
