import 'package:flutter/material.dart';
import '../constants.dart';
import '../size_config.dart';

class ShadowBloc extends StatelessWidget {
  const ShadowBloc(
      {super.key,
      required this.widget,
      this.defPadding = 10,
      this.containerHeight = 200});
  final Widget widget;
  final double defPadding;
  final double containerHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(
        top: getProportionateScreenWidth(20),
      ),
      padding: EdgeInsets.all(getProportionateScreenWidth(defPadding)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black26,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: widget,
    );
  }
}
