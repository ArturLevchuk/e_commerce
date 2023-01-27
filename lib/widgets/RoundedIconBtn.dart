
import 'package:flutter/material.dart';

import '../size_config.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key, required this.icon, required this.press, this.size = 40,
  }) : super(key: key);
  final Icon icon;
  final Function() press;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(size),
      height: getProportionateScreenWidth(size),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: IconButton(
        onPressed: press,
        icon: icon,
      ),
    );
  }
}