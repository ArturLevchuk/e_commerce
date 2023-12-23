import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key,
    required this.icon,
    required this.press,
    this.size = 38, this.color,
  }) : super(key: key);
  final Icon icon;
  final Function() press;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: press,
        icon: icon,
      ),
    );
  }
}
