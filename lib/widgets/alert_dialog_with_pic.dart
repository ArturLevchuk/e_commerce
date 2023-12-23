import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlertDialogTextWithPic extends StatelessWidget {
  const AlertDialogTextWithPic({
    Key? key,
    required this.text,
    required this.svgSrc,
    this.actions,
  }) : super(key: key);

  final String text, svgSrc;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(
          height: 40.w,
          width: 40.w,
          child: SvgPicture.asset(
            svgSrc,
          ),
        ),
      ]),
      actions: actions,
    );
  }
}
