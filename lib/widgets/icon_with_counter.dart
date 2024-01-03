import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWithCounter extends StatelessWidget {
  const IconWithCounter({
    super.key,
    required this.svgSrc,
    int? numOfItems,
    this.color = Colors.grey,
  }) : numOfItems = numOfItems ?? 0;

  final String svgSrc;
  final int numOfItems;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35.w,
      height: 30.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.centerStart,
        children: [
          SizedBox(
            height: 24.w,
            width: 24.w,
            child: SvgPicture.asset(
              svgSrc,
              color: color,
            ),
          ),
          if (numOfItems > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 15.w,
                width: 15.w,
                decoration: const BoxDecoration(
                  color: Color(0xffff4848),
                  shape: BoxShape.circle,
                ),
                child: FittedBox(
                  child: Text(
                    "$numOfItems",
                    style: const TextStyle(
                      color: Colors.white,
                      // fontSize: 10.sp,
                      // height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
