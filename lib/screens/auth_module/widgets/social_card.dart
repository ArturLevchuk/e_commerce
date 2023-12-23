import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String icon;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10).r,
        height: 40.w,
        width: 40.w,
        padding: const EdgeInsets.all(10).r,
        decoration: const BoxDecoration(
          color: Color(0xfff5f6f9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon),
      ),
    );
  }
}
