import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

// class IconBtnWithCounter extends StatelessWidget {
//   const IconBtnWithCounter({
//     Key? key,
//     required this.svgSrc,
//     this.numOfItems = 0,
//     required this.press,
//   }) : super(key: key);

//   final String svgSrc;
//   final int numOfItems;
//   final GestureTapCallback press;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: press,
//       borderRadius: BorderRadius.circular(50).r,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             height: 46.w,
//             width: 46.w,
//             padding: const EdgeInsets.all(11).r,
//             decoration: BoxDecoration(
//               color: kSecondaryColor.withOpacity(.1),
//               shape: BoxShape.circle,
//             ),
//             child: SvgPicture.asset(svgSrc),
//           ),
//           if (numOfItems > 1)
//             Positioned(
//               right: 0,
//               top: 0,
//               child: Container(
//                 height: 16.w,
//                 width: 16.w,
//                 decoration: BoxDecoration(
//                   color: const Color(0xffff4848),
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 1.5, color: Colors.red),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "$numOfItems",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10.sp,
//                       height: 1,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

class IconWithCounter extends StatelessWidget {
  const IconWithCounter({
    super.key,
    required this.svgSrc,
    this.numOfItems = 0,
    this.color = Colors.grey,
  });

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
            // padding: EdgeInsets.all(getProportionateScreenWidth(3)),
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
                decoration: BoxDecoration(
                  color: const Color(0xffff4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.red),
                ),
                child: Center(
                  child: Text(
                    "$numOfItems",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      height: 1,
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
